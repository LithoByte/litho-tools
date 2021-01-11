#!/usr/bin/swift

import Foundation

let projectName = CommandLine.arguments[1]
let projectLibName = CommandLine.arguments[2]

let appfile = """
app_identifier("") # The bundle identifier of your app
apple_id("") # Your Apple email address

itc_team_id("") # App Store Connect Team ID
team_id("") # Developer Portal Team ID

"""
try! appfile.write(toFile: "./fastlane/Appfile", atomically: true, encoding: .utf8)

let fastfile = """
default_platform(:ios)

platform :ios do
  before_all do
    setup_circle_ci
  end
  
  desc "Runs all the tests"
  lane :test do
    scan
  end
  
  desc "Push a new beta build to TestFlight"
  lane :beta do
    increment_build_number(xcodeproj: "\(projectName).xcodeproj")
    disable_automatic_code_signing(path: "\(projectName).xcodeproj")
    match(type: "appstore")
    build_app(workspace: "\(projectName).xcworkspace", scheme: "\(projectName)")
    upload_to_testflight
  end
  
  desc "Deliver screenshots"
  lane :snap do
    capture_screenshots
    upload_to_app_store
  end
  
  desc "Deploy the app"
  lane :release do
    disable_automatic_code_signing(path: "\(projectName).xcodeproj")
    match(type: "appstore")
    build_app(scheme: "\(projectName)",
              workspace: "\(projectName).xcworkspace",
              include_bitcode: true)
    upload_to_app_store
  end
end

"""
try! fastfile.write(toFile: "./fastlane/Fastfile", atomically: true, encoding: .utf8)

let snapfile = """
devices([
   "iPhone 8 Plus",
   "iPhone 11 Pro Max",
   "iPad Pro (12.9-inch) (3rd generation)"
])
languages(["en-US"])
scheme("\(projectLibName)UITests")
output_directory("./screenshots")
clear_previous_screenshots(true)

"""
try! snapfile.write(toFile: "./fastlane/Snapfile", atomically: true, encoding: .utf8)

//let matchfile = """
//git_url("git@github.com:ThryvInc/ios-code-signing.git")
//git_branch("\(projectName)")
//storage_mode("git")
//type("appstore")
//app_identifier([""])
//username("") # Your Apple Developer Portal username
//
//"""
//try! matchfile.write(toFile: "./fastlane/Matchfile", atomically: true, encoding: .utf8)

let gemfile = """
source "https://rubygems.org"
gem "fastlane"

"""
try! gemfile.write(toFile: "./Gemfile", atomically: true, encoding: .utf8)

