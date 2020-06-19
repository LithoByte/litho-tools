#!/usr/bin/swift

import Foundation

let projectName = CommandLine.arguments[1]

let circleCiConfig = """
version: 2
jobs:
  build:
    macos:
      xcode: "11.3.0"
    working_directory: /Users/distiller/project
    environment:
      FL_OUTPUT_DIR: output
    steps:
      - checkout
      - restore_cache:
          key: 1-gems-{{ checksum "Gemfile.lock" }}
      - run: bundle check || bundle install --path vendor/bundle
      - save_cache:
          key: 1-gems-{{ checksum "Gemfile.lock" }}
          paths:
            - vendor/bundle
      - run:
          name: Install CocoaPods
          command: pod install
      - run:
          name: Build and run tests
          command: fastlane scan
          no_output_timeout: 30m
          environment:
            SCAN_DEVICE: iPhone 11
            SCAN_SCHEME: \(projectName)
      - store_test_results:
          path: test_output/report.xml
      - store_artifacts:
          path: /tmp/test-results
          destination: scan-test-results
      - store_artifacts:
          path: ~/Library/Logs/scan
          destination: scan-logs
          
  beta:
    macos:
      xcode: "11.3.0"
    working_directory: /Users/distiller/project
    environment:
      FL_OUTPUT_DIR: output
    steps:
      - checkout
      - restore_cache:
          key: 1-gems-{{ checksum "Gemfile.lock" }}
      - run: bundle check || bundle install --path vendor/bundle
      - save_cache:
          key: 1-gems-{{ checksum "Gemfile.lock" }}
          paths:
            - vendor/bundle
      - run: pod install
      - run:
          name: Publish to Testflight
          command: bundle exec fastlane beta
          no_output_timeout: 1h
      - store_artifacts:
          path: output/\(projectName).ipa
          
  deploy:
    macos:
      xcode: "11.3.0"
    working_directory: /Users/distiller/project
    environment:
      FL_OUTPUT_DIR: output
    steps:
      - checkout
      - restore_cache:
          key: 1-gems-{{ checksum "Gemfile.lock" }}
      - run: bundle check || bundle install --path vendor/bundle
      - save_cache:
          key: 1-gems-{{ checksum "Gemfile.lock" }}
          paths:
            - vendor/bundle
      - run: pod install
      - run:
          command: bundle exec fastlane snap
          no_output_timeout: 1h
      - run:
          command: bundle exec fastlane release
          no_output_timeout: 1h
      - store_artifacts:
          path: screenshots
      - store_artifacts:
          path: output/\(projectName).ipa

workflows:
  version: 2
  beta-publish:
    jobs:
      - beta:
          filters:
            branches:
              only: develop
  publish:
    jobs:
      - deploy:
          filters:
            branches:
              only: master
  testing:
    jobs:
      - build:
          filters:
            branches:
              only: /^feature.*/

"""
try! circleCiConfig.write(toFile: "./.circleci/config.yml", atomically: true, encoding: .utf8)
