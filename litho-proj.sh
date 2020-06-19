#!/bin/bash

mkdir fastlane
mkdir .circleci

touch fastlane/Appfile
touch fastlane/Fastfile
touch fastlane/Snapfile
touch fastlane/Matchfile

touch .circleci/config.yml

touch Podfile

touch .gitignore

~/development/ios/tools/litho-init-circleci.swift $1 $2
~/development/ios/tools/litho-init-fastlane.swift $1 $2
~/development/ios/tools/litho-init-git.swift $1 $2
~/development/ios/tools/litho-init-pods.swift $1 $2

if [ $3 == "--include-login" ]; then
    mkdir $2/AppOpen
    ~/development/ios/tools/litho-init-login.swift $1 $2
fi

pod install
bundle install

