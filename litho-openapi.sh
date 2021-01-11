#!/bin/bash

output_folder=""
template_folder="/Users/ell/development/ios/openapi/templates/swift5"
api_file=""
last_arg=""
for arg in "$@"
do
    if [[ $arg == "-h" ]] || [[ $arg == "--help" ]] || [[ $arg == "help" ]] || [[ $arg == "-?" ]]; then
        echo "Usage of litho-openapi"
        echo "litho-openapi.sh -o output/folder -a api/file.yml [-t /template/folder]"
    fi
    if [[ $last_arg == "-t" ]]; then
        template_folder=$arg
    elif [[ $last_arg == "-o" ]]; then
        output_folder=$arg
    elif [[ $last_arg == "-a" ]]; then
        api_file=$arg
    fi
    
    last_arg=$arg
done

mkdir temp
mkdir "$output_folder"
mkdir "$output_folder/Models"
mkdir "$output_folder/SubAPIs"

openapi-generator generate -g swift5 -t "$template_folder" -o temp -i "$api_file"

mv temp/OpenAPIClient/Classes/OpenAPIs/Models/ "$output_folder/"
mv temp/OpenAPIClient/Classes/OpenAPIs/APIs/* "$output_folder/SubAPIs"
mv temp/OpenAPIClient/Classes/OpenAPIs/Configuration.swift "$output_folder"

rm -r temp
