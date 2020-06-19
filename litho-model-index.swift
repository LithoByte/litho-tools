#!/usr/bin/swift

import Foundation

let args = CommandLine.arguments
let targetName = args[1]
let modelName = args[2]

let capitalizeFirstLetter: (String) -> String = { $0.prefix(1).uppercased() + $0.lowercased().dropFirst() }
let capModel = capitalizeFirstLetter(modelName)

let vcString = """
import LUX
import LithoOperators
import FlexDataSource
import PlaygroundVCHelpers

func \(modelName)sVC() -> \(capModel)sViewController {
    let vc = \(capModel)sViewController.makeFromXIB()
    vc.onViewDidLoad = optionalCast >?> configure(vc:)
    return vc
}

class \(capModel)sViewController: LUXFunctionalTableViewController {
    var viewModel: LUXTableViewModel?
}

func configure(vc: \(capModel)sViewController) {
    let refresher = <#Refreshable#>
    let modelsPublisher = <#AnyPublisher<[\(capModel)], Never>#>
    let vm = viewModel(for: vc.tableView, refresher, modelsPublisher)
    vc.viewModel = vm
    vm.refresh()
}

func viewModel(for tableView: UITableView, _ refresher: Refreshable, _ modelsPub: AnyPublisher<[Model], Never>) -> LUXTableViewModel {
    let itemsPub = modelsPub.map(configure(model:in:) >||> LUXModelItem.init)
    let vm = LUXSectionsTableViewModel(refresher, itemsPub)
    vm.tableView = tableView
    return vm
}

func configure(model: Model, in cell: UITableViewCell) {}

"""

let xib = """
<?xml version="1.0" encoding="UTF-8"?>
<document type="com.apple.InterfaceBuilder3.CocoaTouch.XIB" version="3.0" toolsVersion="15702" targetRuntime="iOS.CocoaTouch" propertyAccessControl="none" useAutolayout="YES" useTraitCollections="YES" useSafeAreas="YES" colorMatched="YES">
    <device id="retina6_1" orientation="portrait" appearance="light"/>
    <dependencies>
        <plugIn identifier="com.apple.InterfaceBuilder.IBCocoaTouchPlugin" version="15704"/>
        <capability name="Safe area layout guides" minToolsVersion="9.0"/>
        <capability name="documents saved in the Xcode 8 format" minToolsVersion="8.0"/>
    </dependencies>
    <objects>
        <placeholder placeholderIdentifier="IBFilesOwner" id="-1" userLabel="File's Owner" customClass="\(capModel)sViewController" customModule="\(targetName)" customModuleProvider="target">
            <connections>
                <outlet property="tableView" destination="z1l-9v-LSq" id="3KD-qL-KPj"/>
                <outlet property="view" destination="i5M-Pr-FkT" id="sfx-zR-JGt"/>
            </connections>
        </placeholder>
        <placeholder placeholderIdentifier="IBFirstResponder" id="-2" customClass="UIResponder"/>
        <view clearsContextBeforeDrawing="NO" contentMode="scaleToFill" id="i5M-Pr-FkT">
            <rect key="frame" x="0.0" y="0.0" width="414" height="896"/>
            <autoresizingMask key="autoresizingMask" widthSizable="YES" heightSizable="YES"/>
            <subviews>
                <tableView clipsSubviews="YES" contentMode="scaleToFill" alwaysBounceVertical="YES" style="plain" separatorStyle="default" rowHeight="-1" estimatedRowHeight="-1" sectionHeaderHeight="28" sectionFooterHeight="28" translatesAutoresizingMaskIntoConstraints="NO" id="z1l-9v-LSq">
                    <rect key="frame" x="0.0" y="44" width="414" height="818"/>
                    <color key="backgroundColor" systemColor="systemBackgroundColor" cocoaTouchSystemColor="whiteColor"/>
                </tableView>
            </subviews>
            <color key="backgroundColor" red="1" green="1" blue="1" alpha="1" colorSpace="custom" customColorSpace="sRGB"/>
            <constraints>
                <constraint firstItem="z1l-9v-LSq" firstAttribute="leading" secondItem="fnl-2z-Ty3" secondAttribute="leading" id="EV1-2T-Akg"/>
                <constraint firstItem="fnl-2z-Ty3" firstAttribute="bottom" secondItem="z1l-9v-LSq" secondAttribute="bottom" id="WPi-dj-gni"/>
                <constraint firstItem="z1l-9v-LSq" firstAttribute="top" secondItem="fnl-2z-Ty3" secondAttribute="top" id="l9h-lv-Ntj"/>
                <constraint firstItem="fnl-2z-Ty3" firstAttribute="trailing" secondItem="z1l-9v-LSq" secondAttribute="trailing" id="xaZ-SJ-SHt"/>
            </constraints>
            <viewLayoutGuide key="safeArea" id="fnl-2z-Ty3"/>
            <point key="canvasLocation" x="131.8840579710145" y="153.34821428571428"/>
        </view>
    </objects>
</document>
"""

try! vcString.write(toFile: "./\(targetName)/\(capModel)sViewController.swift", atomically: true, encoding: .utf8)
try! xib.write(toFile: "./\(targetName)/\(capModel)sViewController.xib", atomically: true, encoding: .utf8)
