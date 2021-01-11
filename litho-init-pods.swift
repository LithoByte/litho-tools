#!/usr/bin/swift

import Foundation

let projectName = CommandLine.arguments[1]
let projectLibName = CommandLine.arguments[2]

let podfile = """
platform :ios, '13.0'

def import_all
  pod 'LUX', git: 'https://github.com/ThryvInc/LUX'
  pod 'LithoOperators', git: 'https://github.com/ThryvInc/LithoOperators'
  pod 'FunNet', git: 'https://github.com/schrockblock/funnet'
  pod 'PlaygroundVCHelpers', git: 'https://github.com/ThryvInc/playground-vc-helpers'
  pod 'FlexDataSource', git: 'https://github.com/ThryvInc/flex-data-source'
  pod 'Slippers'
  pod 'fuikit'
end

target '\(projectLibName)' do
  use_frameworks!
  import_all

  target '\(projectLibName)Tests' do
    inherit! :search_paths
  end

  target '\(projectName)' do
    inherit! :search_paths
    import_all

    target '\(projectName)Tests' do
      inherit! :search_paths
      # Pods for testing
    end
  end
end
"""
try! podfile.write(toFile: "Podfile", atomically: true, encoding: .utf8)
