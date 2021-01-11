#!/bin/bash

# Initialize variables from arguments. Interesting stuff starts on line 60.
project_name=""
framework_name=""
openapi_filename=""
should_include_login=false
should_init_circle=false
should_init_fastlane=false
should_init_git=false
should_init_pods=false
last_arg=""
for arg in "$@"
do
    if [[ $arg == "-h" ]] || [[ $arg == "--help" ]] || [[ $arg == "help" ]] || [[ $arg == "-?" ]]; then
        echo "Usage of litho-proj"
        echo "cd into the project root directory and run this script."
        echo "litho-proj.sh -[gcpflo] -n ProjectName -F FrameworkName [-a openapi/file.yml]"
        echo "In the first argument:"
        echo "including g will set up git"
        echo "including c will set up CircleCI"
        echo "including p will set up Cocoapods"
        echo "including f will set up Fastlane"
        echo "including l will add classes for splash, login, etc."
    fi
    if [[ $last_arg == "-n" ]]; then
        project_name=$arg
    elif [[ $last_arg == "-F" ]]; then
        framework_name=$arg
    elif [[ $last_arg == "-a" ]]; then
        openapi_filename=$arg
    elif [[ $arg == $1 ]] && [[ $arg != "--"* ]]; then
        if [[ $arg =~ "p" ]]; then
            should_init_pods=true
        fi
        if [[ $arg =~ "g" ]]; then
            should_init_git=true
        fi
        if [[ $arg =~ "f" ]]; then
            should_init_fastlane=true
        fi
        if [[ $arg =~ "c" ]]; then
            should_init_circle=true
        fi
        if [[ $arg =~ "l" ]]; then
            should_include_login=true
        fi
    elif [[ $arg == "--pods" ]]; then
        should_init_pods=true
    elif [[ $arg == "--git" ]]; then
        should_init_git=true
    elif [[ $arg == "--fastlane" ]]; then
        should_init_fastlane=true
    elif [[ $arg == "--circleci" ]]; then
        should_init_circle=true
    elif [[ $arg == "--include-login" ]]; then
        should_include_login=true
    fi
    
    last_arg=$arg
done

if [ "$should_init_fastlane" == true ]; then
    echo "Setting up fastlane..."
    mkdir fastlane
    touch fastlane/Appfile
    touch fastlane/Fastfile
    touch fastlane/Snapfile
#    touch fastlane/Matchfile
    ~/development/ios/tools/litho-init-fastlane.swift "$project_name" "$framework_name"
#    bundle install
else
    echo "$last_arg"
fi

if [ "$should_init_circle" == true ]; then
    echo "Setting up CircleCI..."
    mkdir .circleci
    touch .circleci/config.yml
    ~/development/ios/tools/litho-init-circleci.swift "$project_name" "$framework_name"
fi

if [ "$should_init_git" == true ]; then
    echo "Initializing git..."
    touch .gitignore
    ~/development/ios/tools/litho-init-git.swift "$project_name" "$framework_name"
    git init
fi

if [ "$should_include_login" == true ]; then
    echo "Generating login code..."
    mkdir $framework_name/AppOpen
    ~/development/ios/tools/litho-init-login.swift "$project_name" "$framework_name"
fi

if [ "$should_init_pods" == true ]; then
    echo "Setting up Cocoapods..."
    touch Podfile
    ~/development/ios/tools/litho-init-pods.swift "$project_name" "$framework_name"
    pod install
fi

if [ ! -z "$openapi_filename" ]; then
    echo "Generating API files from $openapi_filename"
    ~/development/ios/tools/litho-openapi.sh -o "$framework_name/Network" -a "$openapi_filename"
fi
