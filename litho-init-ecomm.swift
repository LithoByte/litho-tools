#!/usr/bin/swift

import Foundation

let projectName = CommandLine.arguments[1]
let projectLibName = CommandLine.arguments[2]

let appOpen = """
import LUX
import Prelude
import LithoOperators
import FunNet
import Combine

open class AppOpenFlowController: LUXAppOpenFlowController {
    var cancelBag = Set<AnyCancellable>()
    
    public override init() {
        super.init()
        LUXSessionManager.primarySession = LUXUserDefaultsSession(host: <#Host Name#>, authHeaderKey: <#Authorization Header#> )
        splashViewModel = LUXSplashViewModel(minimumVisibleTime: 1.0, otherTasks: nil)
        setupLogin()
    }

    open override func initialVC() -> UIViewController? {
        let splashVC = splashViewController(splashViewModel)
        splashVC.modalTransitionStyle = .crossDissolve

        splashViewModel?.outputs.advanceAuthedPublisher.sink { [unowned self] _ in
            <#go to logged in state#>
        }.store(in: &cancelBag)
        splashViewModel?.outputs.advanceUnauthedPublisher.sink { [unowned self] _ in
            splashVC.present(self.landingVC(), animated: true, completion: nil)
        }.store(in: &cancelBag)

        return splashVC
    }

    open func landingVC() -> UIViewController {
        let landingVC = landingViewController()
        if let landingVC = landingVC as? LandingViewController {
            landingVC.onLoginPressed = { $0.present(self.loginVC(), animated: true, completion: nil) }
            landingVC.onSignUpPressed = { $0.present(self.registerVC(), animated: true, completion: nil) }
        }
        return landingVC
    }

    open func registerVC() -> UIViewController {
        return signUpViewController()
    }

    open func loginVC() -> UIViewController {
        let loginVC = loginViewController(loginViewModel)
        loginVC.modalTransitionStyle = .crossDissolve
        loginVC.modalPresentationStyle = .fullScreen
        
        loginViewModel?.advanceAuthedPublisher.sink { [unowned self] _ in
            <#go to logged in state#>
        }.store(in: &cancelBag)
        loginViewModel?.credentialLoginCall?.responder?.$serverError.sink { [weak loginVC] (error) in
            if let e = error {
                loginVC?.show(VerboseLoginErrorHandler().alert(for: e), sender: loginVC)
            }
        }.store(in: &cancelBag)

        return loginVC
    }

    func setupLogin() {
        let call = <#Login Network Call#>
        loginViewModel = LUXLoginViewModel(credsCall: call, loginModelToJson: <#(String, String) -> Codable#>) { data in
            let loginData = try? JsonProvider.decode(<#AuthResponse type#>.self, from: data)
            if let authToken = <#Authorization Token#> {
                let hostName = <#Host Name#>
                let session = LUXUserDefaultsSession(host: hostName, authHeaderKey: <#Authorization Header#> )
                session.setAuthValue(authString: authToken)
                LUXSessionManager.primarySession = session
                return true
            }
            return false
        }
    }
}

"""

func splashVCDef() -> String {
    return """
import LUX
import PlaygroundVCHelpers

func splashViewController(_ vm: LUXSplashViewModel?) -> UIViewController {
    let vc = SplashViewController.makeFromXIB()
    vc.viewModel = vm
    return vc
}

class SplashViewController: LUXSplashViewController {}
"""
}
func splashXib() -> String {
    return """
<?xml version="1.0" encoding="UTF-8"?>
<document type="com.apple.InterfaceBuilder3.CocoaTouch.XIB" version="3.0" toolsVersion="15702" targetRuntime="iOS.CocoaTouch" propertyAccessControl="none" useAutolayout="YES" useTraitCollections="YES" useSafeAreas="YES" colorMatched="YES">
    <device id="retina6_1" orientation="portrait" appearance="light"/>
    <dependencies>
        <plugIn identifier="com.apple.InterfaceBuilder.IBCocoaTouchPlugin" version="15704"/>
        <capability name="Safe area layout guides" minToolsVersion="9.0"/>
        <capability name="documents saved in the Xcode 8 format" minToolsVersion="8.0"/>
    </dependencies>
    <objects>
        <placeholder placeholderIdentifier="IBFilesOwner" id="-1" userLabel="File's Owner" customClass="SplashViewController" customModule="\(projectLibName)" customModuleProvider="target">
            <connections>
                <outlet property="activityIndicator" destination="8d5-VV-szu" id="MkW-Ig-AuR"/>
                <outlet property="bgImageView" destination="2en-f4-iw5" id="Loe-cB-fGv"/>
                <outlet property="logoImageView" destination="CPc-JH-d1f" id="R8f-bA-TPS"/>
                <outlet property="logoTopConstraint" destination="pLK-M1-7M3" id="R86-7m-EC0"/>
                <outlet property="view" destination="i5M-Pr-FkT" id="sfx-zR-JGt"/>
            </connections>
        </placeholder>
        <placeholder placeholderIdentifier="IBFirstResponder" id="-2" customClass="UIResponder"/>
        <view clearsContextBeforeDrawing="NO" contentMode="scaleToFill" id="i5M-Pr-FkT">
            <rect key="frame" x="0.0" y="0.0" width="414" height="896"/>
            <autoresizingMask key="autoresizingMask" widthSizable="YES" heightSizable="YES"/>
            <subviews>
                <imageView clipsSubviews="YES" userInteractionEnabled="NO" contentMode="scaleAspectFit" horizontalHuggingPriority="251" verticalHuggingPriority="251" translatesAutoresizingMaskIntoConstraints="NO" id="2en-f4-iw5">
                    <rect key="frame" x="0.0" y="0.0" width="414" height="896"/>
                </imageView>
                <activityIndicatorView opaque="NO" contentMode="scaleToFill" horizontalHuggingPriority="750" verticalHuggingPriority="750" ambiguous="YES" style="medium" translatesAutoresizingMaskIntoConstraints="NO" id="8d5-VV-szu">
                    <rect key="frame" x="197" y="379" width="20" height="20"/>
                </activityIndicatorView>
                <imageView clipsSubviews="YES" userInteractionEnabled="NO" contentMode="scaleAspectFit" horizontalHuggingPriority="251" verticalHuggingPriority="251" ambiguous="YES" translatesAutoresizingMaskIntoConstraints="NO" id="CPc-JH-d1f">
                    <rect key="frame" x="87" y="186" width="240" height="128"/>
                </imageView>
            </subviews>
            <color key="backgroundColor" red="1" green="1" blue="1" alpha="1" colorSpace="custom" customColorSpace="sRGB"/>
            <constraints>
                <constraint firstItem="2en-f4-iw5" firstAttribute="leading" secondItem="i5M-Pr-FkT" secondAttribute="leading" id="2fU-wS-C1N"/>
                <constraint firstAttribute="trailing" secondItem="2en-f4-iw5" secondAttribute="trailing" id="ALi-Kc-GXr"/>
                <constraint firstItem="2en-f4-iw5" firstAttribute="bottom" secondItem="i5M-Pr-FkT" secondAttribute="bottom" id="Iny-L8-NDK"/>
                <constraint firstItem="8d5-VV-szu" firstAttribute="top" secondItem="CPc-JH-d1f" secondAttribute="bottom" constant="60" id="JIc-3I-w2p"/>
                <constraint firstAttribute="top" secondItem="2en-f4-iw5" secondAttribute="top" id="Tip-3T-pEZ"/>
                <constraint firstItem="CPc-JH-d1f" firstAttribute="top" secondItem="fnl-2z-Ty3" secondAttribute="top" constant="150" id="pLK-M1-7M3"/>
                <constraint firstItem="CPc-JH-d1f" firstAttribute="centerX" secondItem="fnl-2z-Ty3" secondAttribute="centerX" id="wTS-Ya-9Jn"/>
                <constraint firstItem="8d5-VV-szu" firstAttribute="centerX" secondItem="fnl-2z-Ty3" secondAttribute="centerX" id="yTq-iY-Msu"/>
            </constraints>
            <viewLayoutGuide key="safeArea" id="fnl-2z-Ty3"/>
            <point key="canvasLocation" x="137.68115942028987" y="144.64285714285714"/>
        </view>
    </objects>
</document>

"""
}

func loginVCDef() -> String {
    return """
import LUX
import PlaygroundVCHelpers

func loginViewController(_ vm: LUXLoginViewModel?) -> UIViewController {
    let vc = LoginViewController.makeFromXIB()
    vc.loginViewModel = vm
    return vc
}

class LoginViewController: LUXLoginViewController {}
"""
}
func loginXib() -> String {
    return """
<?xml version="1.0" encoding="UTF-8"?>
<document type="com.apple.InterfaceBuilder3.CocoaTouch.XIB" version="3.0" toolsVersion="15702" targetRuntime="iOS.CocoaTouch" propertyAccessControl="none" useAutolayout="YES" useTraitCollections="YES" useSafeAreas="YES" colorMatched="YES">
    <device id="retina6_1" orientation="portrait" appearance="light"/>
    <dependencies>
        <plugIn identifier="com.apple.InterfaceBuilder.IBCocoaTouchPlugin" version="15704"/>
        <capability name="Safe area layout guides" minToolsVersion="9.0"/>
        <capability name="documents saved in the Xcode 8 format" minToolsVersion="8.0"/>
    </dependencies>
    <objects>
        <placeholder placeholderIdentifier="IBFilesOwner" id="-1" userLabel="File's Owner" customClass="LoginViewController" customModule="\(projectLibName)" customModuleProvider="target">
            <connections>
                <outlet property="forgotPasswordButton" destination="QtP-OY-4W3" id="iPp-Dq-PNA"/>
                <outlet property="legalButton" destination="bs4-J0-JDT" id="3l3-8C-JUz"/>
                <outlet property="loginButton" destination="GAM-Sd-P0o" id="Jlu-eW-A1U"/>
                <outlet property="loginHeight" destination="JeY-9G-eUo" id="7jS-F6-Snh"/>
                <outlet property="logoHeight" destination="oI0-n1-GmB" id="bWn-b1-GUq"/>
                <outlet property="logoImageView" destination="6kJ-Hx-FMJ" id="YUJ-lA-Pch"/>
                <outlet property="passwordTextField" destination="R7Q-he-D1X" id="XmZ-tq-GFR"/>
                <outlet property="signUpButton" destination="iOg-Mj-t8J" id="pnQ-YT-yiI"/>
                <outlet property="spinner" destination="AGS-Ko-oC9" id="KTd-hY-ndE"/>
                <outlet property="usernameTextField" destination="mzo-Zd-pbM" id="eJn-ml-OsK"/>
                <outlet property="view" destination="i5M-Pr-FkT" id="sfx-zR-JGt"/>
            </connections>
        </placeholder>
        <placeholder placeholderIdentifier="IBFirstResponder" id="-2" customClass="UIResponder"/>
        <view clearsContextBeforeDrawing="NO" contentMode="scaleToFill" id="i5M-Pr-FkT">
            <rect key="frame" x="0.0" y="0.0" width="414" height="896"/>
            <autoresizingMask key="autoresizingMask" widthSizable="YES" heightSizable="YES"/>
            <subviews>
                <textField opaque="NO" contentMode="scaleToFill" contentHorizontalAlignment="left" contentVerticalAlignment="center" borderStyle="roundedRect" placeholder="Username" textAlignment="natural" minimumFontSize="17" translatesAutoresizingMaskIntoConstraints="NO" id="mzo-Zd-pbM">
                    <rect key="frame" x="16" y="219" width="382" height="34"/>
                    <fontDescription key="fontDescription" type="system" pointSize="14"/>
                    <textInputTraits key="textInputTraits" textContentType="username"/>
                    <connections>
                        <action selector="usernameChanged" destination="-1" eventType="editingChanged" id="eCK-A3-jGC"/>
                    </connections>
                </textField>
                <textField opaque="NO" contentMode="scaleToFill" contentHorizontalAlignment="left" contentVerticalAlignment="center" borderStyle="roundedRect" placeholder="Password" textAlignment="natural" minimumFontSize="17" translatesAutoresizingMaskIntoConstraints="NO" id="R7Q-he-D1X">
                    <rect key="frame" x="16" y="261" width="382" height="34"/>
                    <fontDescription key="fontDescription" type="system" pointSize="14"/>
                    <textInputTraits key="textInputTraits" secureTextEntry="YES" textContentType="password"/>
                    <connections>
                        <action selector="passwordChanged" destination="-1" eventType="editingChanged" id="z3z-1l-wTc"/>
                    </connections>
                </textField>
                <button opaque="NO" contentMode="scaleToFill" contentHorizontalAlignment="center" contentVerticalAlignment="center" buttonType="roundedRect" lineBreakMode="middleTruncation" translatesAutoresizingMaskIntoConstraints="NO" id="GAM-Sd-P0o">
                    <rect key="frame" x="16" y="303" width="382" height="41"/>
                    <color key="backgroundColor" red="0.0" green="0.47843137250000001" blue="1" alpha="1" colorSpace="custom" customColorSpace="sRGB"/>
                    <constraints>
                        <constraint firstAttribute="height" constant="41" id="JeY-9G-eUo"/>
                    </constraints>
                    <color key="tintColor" white="1" alpha="1" colorSpace="custom" customColorSpace="genericGamma22GrayColorSpace"/>
                    <state key="normal" title="Login"/>
                    <connections>
                        <action selector="loginButtonPressed" destination="-1" eventType="touchUpInside" id="uyb-7h-CfW"/>
                    </connections>
                </button>
                <button opaque="NO" contentMode="scaleToFill" contentHorizontalAlignment="center" contentVerticalAlignment="center" buttonType="roundedRect" lineBreakMode="middleTruncation" translatesAutoresizingMaskIntoConstraints="NO" id="iOg-Mj-t8J">
                    <rect key="frame" x="16" y="801" width="382" height="41"/>
                    <constraints>
                        <constraint firstAttribute="height" constant="41" id="1P9-pB-L8t"/>
                    </constraints>
                    <fontDescription key="fontDescription" type="system" pointSize="13"/>
                    <state key="normal" title="Sign Up"/>
                    <connections>
                        <action selector="signUpPressed" destination="-1" eventType="touchUpInside" id="DWV-YA-Afv"/>
                    </connections>
                </button>
                <imageView clipsSubviews="YES" userInteractionEnabled="NO" contentMode="scaleAspectFit" horizontalHuggingPriority="251" verticalHuggingPriority="251" translatesAutoresizingMaskIntoConstraints="NO" id="6kJ-Hx-FMJ">
                    <rect key="frame" x="16" y="70" width="382" height="141"/>
                    <constraints>
                        <constraint firstAttribute="height" constant="141" id="oI0-n1-GmB"/>
                    </constraints>
                </imageView>
                <activityIndicatorView hidden="YES" opaque="NO" contentMode="scaleToFill" horizontalHuggingPriority="750" verticalHuggingPriority="750" animating="YES" style="gray" translatesAutoresizingMaskIntoConstraints="NO" id="AGS-Ko-oC9">
                    <rect key="frame" x="197" y="360" width="20" height="20"/>
                </activityIndicatorView>
                <button opaque="NO" contentMode="scaleToFill" contentHorizontalAlignment="center" contentVerticalAlignment="center" buttonType="roundedRect" lineBreakMode="middleTruncation" translatesAutoresizingMaskIntoConstraints="NO" id="QtP-OY-4W3">
                    <rect key="frame" x="296" y="354" width="102" height="28"/>
                    <fontDescription key="fontDescription" type="system" pointSize="13"/>
                    <state key="normal" title="Forgot Password"/>
                    <connections>
                        <action selector="forgotPasswordPressed" destination="-1" eventType="touchUpInside" id="KUZ-Pk-Agd"/>
                    </connections>
                </button>
                <button opaque="NO" contentMode="scaleToFill" contentHorizontalAlignment="center" contentVerticalAlignment="center" buttonType="roundedRect" lineBreakMode="middleTruncation" translatesAutoresizingMaskIntoConstraints="NO" id="bs4-J0-JDT">
                    <rect key="frame" x="279" y="390" width="119" height="28"/>
                    <fontDescription key="fontDescription" type="system" pointSize="13"/>
                    <state key="normal" title="Terms &amp; Conditions"/>
                    <connections>
                        <action selector="forgotPasswordPressed" destination="-1" eventType="touchUpInside" id="eWx-ub-RAJ"/>
                        <action selector="termsPressed" destination="-1" eventType="touchUpInside" id="bsc-ak-KzB"/>
                    </connections>
                </button>
            </subviews>
            <color key="backgroundColor" red="1" green="1" blue="1" alpha="1" colorSpace="custom" customColorSpace="sRGB"/>
            <constraints>
                <constraint firstItem="R7Q-he-D1X" firstAttribute="trailing" secondItem="mzo-Zd-pbM" secondAttribute="trailing" id="4eo-0T-PN8"/>
                <constraint firstItem="R7Q-he-D1X" firstAttribute="leading" secondItem="mzo-Zd-pbM" secondAttribute="leading" id="6qd-oC-bjS"/>
                <constraint firstItem="R7Q-he-D1X" firstAttribute="top" secondItem="mzo-Zd-pbM" secondAttribute="bottom" constant="8" id="Bza-d9-mQm"/>
                <constraint firstItem="QtP-OY-4W3" firstAttribute="top" secondItem="GAM-Sd-P0o" secondAttribute="bottom" constant="10" id="Dah-wc-ze3"/>
                <constraint firstItem="QtP-OY-4W3" firstAttribute="trailing" secondItem="GAM-Sd-P0o" secondAttribute="trailing" id="I18-lK-ITj"/>
                <constraint firstItem="6kJ-Hx-FMJ" firstAttribute="top" secondItem="fnl-2z-Ty3" secondAttribute="top" constant="26" id="JJ3-sX-fPH"/>
                <constraint firstItem="6kJ-Hx-FMJ" firstAttribute="leading" secondItem="fnl-2z-Ty3" secondAttribute="leading" constant="16" id="PS7-ru-mN3"/>
                <constraint firstItem="AGS-Ko-oC9" firstAttribute="top" secondItem="GAM-Sd-P0o" secondAttribute="bottom" constant="16" id="Sal-Jp-imU"/>
                <constraint firstItem="fnl-2z-Ty3" firstAttribute="trailing" secondItem="6kJ-Hx-FMJ" secondAttribute="trailing" constant="16" id="XPf-zb-5f5"/>
                <constraint firstItem="GAM-Sd-P0o" firstAttribute="top" secondItem="R7Q-he-D1X" secondAttribute="bottom" constant="8" id="Zwg-yo-byi"/>
                <constraint firstItem="mzo-Zd-pbM" firstAttribute="top" secondItem="6kJ-Hx-FMJ" secondAttribute="bottom" constant="8" id="bKN-tZ-onx"/>
                <constraint firstItem="GAM-Sd-P0o" firstAttribute="trailing" secondItem="R7Q-he-D1X" secondAttribute="trailing" id="bVU-lI-g2P"/>
                <constraint firstItem="GAM-Sd-P0o" firstAttribute="leading" secondItem="R7Q-he-D1X" secondAttribute="leading" id="gZV-z6-XjR"/>
                <constraint firstItem="mzo-Zd-pbM" firstAttribute="leading" secondItem="fnl-2z-Ty3" secondAttribute="leading" constant="16" id="jep-Lf-OaO"/>
                <constraint firstItem="fnl-2z-Ty3" firstAttribute="bottom" secondItem="iOg-Mj-t8J" secondAttribute="bottom" constant="20" id="k0l-Mq-XEF"/>
                <constraint firstItem="AGS-Ko-oC9" firstAttribute="centerX" secondItem="fnl-2z-Ty3" secondAttribute="centerX" id="qIq-1j-q8v"/>
                <constraint firstItem="bs4-J0-JDT" firstAttribute="trailing" secondItem="QtP-OY-4W3" secondAttribute="trailing" id="qpS-vQ-cEW"/>
                <constraint firstItem="iOg-Mj-t8J" firstAttribute="leading" secondItem="fnl-2z-Ty3" secondAttribute="leading" constant="16" id="t1N-oI-0qZ"/>
                <constraint firstItem="fnl-2z-Ty3" firstAttribute="trailing" secondItem="iOg-Mj-t8J" secondAttribute="trailing" constant="16" id="twx-dg-AcO"/>
                <constraint firstItem="fnl-2z-Ty3" firstAttribute="trailing" secondItem="mzo-Zd-pbM" secondAttribute="trailing" constant="16" id="vaD-wX-gDo"/>
                <constraint firstItem="bs4-J0-JDT" firstAttribute="top" secondItem="QtP-OY-4W3" secondAttribute="bottom" constant="8" id="w08-VH-10w"/>
            </constraints>
            <viewLayoutGuide key="safeArea" id="fnl-2z-Ty3"/>
            <point key="canvasLocation" x="-926.08695652173924" y="-11.383928571428571"/>
        </view>
    </objects>
</document>

"""
}

func landingVCDef() -> String {
    return """
import LUX
import PlaygroundVCHelpers

func landingVC() -> UIViewController {
    return LandingViewController.makeFromXIB()
}

class LandingViewController: LUXLandingViewController {}
"""
}
func landingXib() -> String {
    return """
<?xml version="1.0" encoding="UTF-8"?>
<document type="com.apple.InterfaceBuilder3.CocoaTouch.XIB" version="3.0" toolsVersion="15702" targetRuntime="iOS.CocoaTouch" propertyAccessControl="none" useAutolayout="YES" useTraitCollections="YES" useSafeAreas="YES" colorMatched="YES">
    <device id="retina6_1" orientation="portrait" appearance="light"/>
    <dependencies>
        <plugIn identifier="com.apple.InterfaceBuilder.IBCocoaTouchPlugin" version="15704"/>
        <capability name="Safe area layout guides" minToolsVersion="9.0"/>
        <capability name="documents saved in the Xcode 8 format" minToolsVersion="8.0"/>
    </dependencies>
    <objects>
        <placeholder placeholderIdentifier="IBFilesOwner" id="-1" userLabel="File's Owner" customClass="LandingViewController" customModule="\(projectLibName)" customModuleProvider="target">
            <connections>
                <outlet property="backgroundImageView" destination="vDR-gU-hQd" id="qVo-9x-CmN"/>
                <outlet property="loginButton" destination="Dbf-Qd-x8P" id="pg9-wl-GXz"/>
                <outlet property="logoImageView" destination="XHm-9r-6W6" id="MA5-LF-2gX"/>
                <outlet property="signUpButton" destination="Rmo-Hf-o0k" id="65N-8Y-KWt"/>
                <outlet property="view" destination="i5M-Pr-FkT" id="sfx-zR-JGt"/>
            </connections>
        </placeholder>
        <placeholder placeholderIdentifier="IBFirstResponder" id="-2" customClass="UIResponder"/>
        <view clearsContextBeforeDrawing="NO" contentMode="scaleToFill" id="i5M-Pr-FkT">
            <rect key="frame" x="0.0" y="0.0" width="414" height="896"/>
            <autoresizingMask key="autoresizingMask" widthSizable="YES" heightSizable="YES"/>
            <subviews>
                <imageView clipsSubviews="YES" userInteractionEnabled="NO" contentMode="scaleAspectFit" horizontalHuggingPriority="251" verticalHuggingPriority="251" translatesAutoresizingMaskIntoConstraints="NO" id="vDR-gU-hQd">
                    <rect key="frame" x="0.0" y="0.0" width="414" height="896"/>
                </imageView>
                <button opaque="NO" contentMode="scaleToFill" contentHorizontalAlignment="center" contentVerticalAlignment="center" buttonType="roundedRect" lineBreakMode="middleTruncation" translatesAutoresizingMaskIntoConstraints="NO" id="Rmo-Hf-o0k">
                    <rect key="frame" x="217" y="832" width="181" height="30"/>
                    <state key="normal" title="Sign Up"/>
                    <connections>
                        <action selector="signUpPressed" destination="-1" eventType="touchUpInside" id="DkL-14-bX4"/>
                    </connections>
                </button>
                <button opaque="NO" contentMode="scaleToFill" contentHorizontalAlignment="center" contentVerticalAlignment="center" buttonType="roundedRect" lineBreakMode="middleTruncation" translatesAutoresizingMaskIntoConstraints="NO" id="Dbf-Qd-x8P">
                    <rect key="frame" x="20" y="832" width="181" height="30"/>
                    <state key="normal" title="Login"/>
                    <connections>
                        <action selector="loginPressed" destination="-1" eventType="touchUpInside" id="KNL-2Q-PbX"/>
                    </connections>
                </button>
                <imageView clipsSubviews="YES" userInteractionEnabled="NO" contentMode="scaleAspectFit" horizontalHuggingPriority="251" verticalHuggingPriority="251" ambiguous="YES" translatesAutoresizingMaskIntoConstraints="NO" id="XHm-9r-6W6">
                    <rect key="frame" x="87" y="193" width="240" height="128"/>
                </imageView>
            </subviews>
            <color key="backgroundColor" red="1" green="1" blue="1" alpha="1" colorSpace="custom" customColorSpace="sRGB"/>
            <constraints>
                <constraint firstItem="Rmo-Hf-o0k" firstAttribute="centerY" secondItem="Dbf-Qd-x8P" secondAttribute="centerY" id="2k0-Rn-s7i"/>
                <constraint firstItem="XHm-9r-6W6" firstAttribute="top" secondItem="fnl-2z-Ty3" secondAttribute="top" constant="149" id="DBw-OP-faS"/>
                <constraint firstItem="Dbf-Qd-x8P" firstAttribute="leading" secondItem="fnl-2z-Ty3" secondAttribute="leading" constant="20" id="JEx-OU-zC9"/>
                <constraint firstItem="vDR-gU-hQd" firstAttribute="bottom" secondItem="i5M-Pr-FkT" secondAttribute="bottom" id="Jt0-kr-q7z"/>
                <constraint firstItem="fnl-2z-Ty3" firstAttribute="bottom" secondItem="Dbf-Qd-x8P" secondAttribute="bottom" id="LGe-u8-IjY"/>
                <constraint firstItem="Rmo-Hf-o0k" firstAttribute="width" secondItem="Dbf-Qd-x8P" secondAttribute="width" id="P3r-iB-Kl0"/>
                <constraint firstItem="fnl-2z-Ty3" firstAttribute="trailing" secondItem="Rmo-Hf-o0k" secondAttribute="trailing" constant="16" id="QaD-AR-PWN"/>
                <constraint firstItem="Rmo-Hf-o0k" firstAttribute="bottom" secondItem="Dbf-Qd-x8P" secondAttribute="bottom" id="TgC-Ie-ZTU"/>
                <constraint firstAttribute="top" secondItem="vDR-gU-hQd" secondAttribute="top" id="dFj-be-3rm"/>
                <constraint firstItem="Rmo-Hf-o0k" firstAttribute="leading" secondItem="Dbf-Qd-x8P" secondAttribute="trailing" constant="16" id="eXN-B6-osI"/>
                <constraint firstItem="vDR-gU-hQd" firstAttribute="leading" secondItem="i5M-Pr-FkT" secondAttribute="leading" id="iFq-gM-ZMm"/>
                <constraint firstAttribute="trailing" secondItem="vDR-gU-hQd" secondAttribute="trailing" id="qN8-63-oLu"/>
                <constraint firstItem="XHm-9r-6W6" firstAttribute="centerX" secondItem="fnl-2z-Ty3" secondAttribute="centerX" id="uLj-Kb-AI5"/>
            </constraints>
            <viewLayoutGuide key="safeArea" id="fnl-2z-Ty3"/>
            <point key="canvasLocation" x="131.8840579710145" y="153.34821428571428"/>
        </view>
    </objects>
</document>

"""
}

func signUpVCDef() -> String {
    return """
import LUX
import fuikit
import PlaygroundVCHelpers

func signUpViewController() -> UIViewController {
    return SignUpViewController.makeFromXIB()
}

class SignUpViewController: FUIViewController {}
"""
}
func signUpXib() -> String {
    return """
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<document type="com.apple.InterfaceBuilder3.CocoaTouch.XIB" version="3.0" toolsVersion="13142" targetRuntime="iOS.CocoaTouch" propertyAccessControl="none" useAutolayout="YES" useTraitCollections="YES" useSafeAreas="YES" colorMatched="YES">
    <dependencies>
        <plugIn identifier="com.apple.InterfaceBuilder.IBCocoaTouchPlugin" version="12042"/>
        <capability name="Safe area layout guides" minToolsVersion="9.0"/>
        <capability name="documents saved in the Xcode 8 format" minToolsVersion="8.0"/>
    </dependencies>
    <objects>
        <placeholder placeholderIdentifier="IBFilesOwner" id="-1" userLabel="File's Owner" customClass="SignUpViewController" customModule="\(projectLibName)" customModuleProvider="target">
            <connections>
                <outlet property="view" destination="i5M-Pr-FkT" id="sfx-zR-JGt"/>
            </connections>
        </placeholder>
        <placeholder placeholderIdentifier="IBFirstResponder" id="-2" customClass="UIResponder"/>
        <view clearsContextBeforeDrawing="NO" contentMode="scaleToFill" id="i5M-Pr-FkT">
            <rect key="frame" x="0.0" y="0.0" width="375" height="667"/>
            <autoresizingMask key="autoresizingMask" widthSizable="YES" heightSizable="YES"/>
            <color key="backgroundColor" red="1" green="1" blue="1" alpha="1" colorSpace="custom" customColorSpace="sRGB"/>
            <viewLayoutGuide key="safeArea" id="fnl-2z-Ty3"/>
        </view>
    </objects>
</document>

"""
}

func forgotPasswordVCDef() -> String {
    return """
import LUX
import PlaygroundVCHelpers

func forgotPasswordVC() -> UIViewController {
    return ForgotPasswordViewController.makeFromXIB()
}

class ForgotPasswordViewController: LUXForgotPasswordViewController {}
"""
}
func forgotPasswordXib() -> String {
    return """
<?xml version="1.0" encoding="UTF-8"?>
<document type="com.apple.InterfaceBuilder3.CocoaTouch.XIB" version="3.0" toolsVersion="15400" targetRuntime="iOS.CocoaTouch" propertyAccessControl="none" useAutolayout="YES" useTraitCollections="YES" useSafeAreas="YES" colorMatched="YES">
    <dependencies>
        <plugIn identifier="com.apple.InterfaceBuilder.IBCocoaTouchPlugin" version="15404"/>
        <capability name="Safe area layout guides" minToolsVersion="9.0"/>
        <capability name="documents saved in the Xcode 8 format" minToolsVersion="8.0"/>
    </dependencies>
    <objects>
        <placeholder placeholderIdentifier="IBFilesOwner" id="-1" userLabel="File's Owner" customClass="ForgotPasswordViewController" customModule="\(projectLibName)" customModuleProvider="target">
            <connections>
                <outlet property="identifierTextField" destination="XTX-T7-VU6" id="O9v-2R-fNB"/>
                <outlet property="resetButton" destination="sAa-K1-Pso" id="Beq-g0-Goy"/>
                <outlet property="view" destination="i5M-Pr-FkT" id="sfx-zR-JGt"/>
            </connections>
        </placeholder>
        <placeholder placeholderIdentifier="IBFirstResponder" id="-2" customClass="UIResponder"/>
        <view clearsContextBeforeDrawing="NO" contentMode="scaleToFill" id="i5M-Pr-FkT">
            <rect key="frame" x="0.0" y="0.0" width="414" height="896"/>
            <autoresizingMask key="autoresizingMask" widthSizable="YES" heightSizable="YES"/>
            <subviews>
                <textField opaque="NO" contentMode="scaleToFill" contentHorizontalAlignment="left" contentVerticalAlignment="center" borderStyle="roundedRect" placeholder="Email associated with your account" textAlignment="natural" minimumFontSize="17" translatesAutoresizingMaskIntoConstraints="NO" id="XTX-T7-VU6">
                    <rect key="frame" x="20" y="16" width="374" height="34"/>
                    <fontDescription key="fontDescription" type="system" pointSize="14"/>
                    <textInputTraits key="textInputTraits"/>
                </textField>
                <button opaque="NO" contentMode="scaleToFill" contentHorizontalAlignment="center" contentVerticalAlignment="center" buttonType="roundedRect" lineBreakMode="middleTruncation" translatesAutoresizingMaskIntoConstraints="NO" id="sAa-K1-Pso">
                    <rect key="frame" x="20" y="58" width="374" height="30"/>
                    <state key="normal" title="Reset Password"/>
                    <connections>
                        <action selector="resetPressed" destination="-1" eventType="touchUpInside" id="w9b-Qt-oxW"/>
                    </connections>
                </button>
            </subviews>
            <color key="backgroundColor" red="1" green="1" blue="1" alpha="1" colorSpace="custom" customColorSpace="sRGB"/>
            <constraints>
                <constraint firstItem="XTX-T7-VU6" firstAttribute="top" secondItem="fnl-2z-Ty3" secondAttribute="top" constant="16" id="CR8-pY-QLx"/>
                <constraint firstItem="sAa-K1-Pso" firstAttribute="trailing" secondItem="XTX-T7-VU6" secondAttribute="trailing" id="H2U-EN-U0n"/>
                <constraint firstItem="fnl-2z-Ty3" firstAttribute="trailing" secondItem="XTX-T7-VU6" secondAttribute="trailing" constant="20" id="P7K-nM-joR"/>
                <constraint firstItem="XTX-T7-VU6" firstAttribute="leading" secondItem="fnl-2z-Ty3" secondAttribute="leading" constant="20" id="UQj-2U-VMQ"/>
                <constraint firstItem="sAa-K1-Pso" firstAttribute="top" secondItem="XTX-T7-VU6" secondAttribute="bottom" constant="8" id="bkh-VR-EeL"/>
                <constraint firstItem="sAa-K1-Pso" firstAttribute="leading" secondItem="XTX-T7-VU6" secondAttribute="leading" id="fQF-Cf-B9i"/>
            </constraints>
            <viewLayoutGuide key="safeArea" id="fnl-2z-Ty3"/>
            <point key="canvasLocation" x="-346" y="143"/>
        </view>
    </objects>
</document>

"""
}

try! appOpen.write(toFile: "./\(projectLibName)/AppOpen/AppOpen.swift", atomically: true, encoding: .utf8)
try! splashVCDef().write(toFile: "./\(projectLibName)/AppOpen/SplashViewController.swift", atomically: true, encoding: .utf8)
try! splashXib().write(toFile: "./\(projectLibName)/AppOpen/SplashViewController.xib", atomically: true, encoding: .utf8)
try! loginVCDef().write(toFile: "./\(projectLibName)/AppOpen/LoginViewController.swift", atomically: true, encoding: .utf8)
try! loginXib().write(toFile: "./\(projectLibName)/AppOpen/LoginViewController.xib", atomically: true, encoding: .utf8)
try! landingVCDef().write(toFile: "./\(projectLibName)/AppOpen/LandingViewController.swift", atomically: true, encoding: .utf8)
try! landingXib().write(toFile: "./\(projectLibName)/AppOpen/LandingViewController.xib", atomically: true, encoding: .utf8)
try! signUpVCDef().write(toFile: "./\(projectLibName)/AppOpen/SignUpViewController.swift", atomically: true, encoding: .utf8)
try! signUpXib().write(toFile: "./\(projectLibName)/AppOpen/SignUpViewController.xib", atomically: true, encoding: .utf8)
try! forgotPasswordVCDef().write(toFile: "./\(projectLibName)/AppOpen/ForgotPasswordViewController.swift", atomically: true, encoding: .utf8)
try! forgotPasswordXib().write(toFile: "./\(projectLibName)/AppOpen/ForgotPasswordViewController.xib", atomically: true, encoding: .utf8)
