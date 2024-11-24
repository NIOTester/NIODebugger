#!/bin/bash

folder_name=$(basename "$(pwd)")

class_name=$(echo "$folder_name" | awk -F'.' '{print $(NF-1)}')

java_file_path=$(find $1/src/test/java/ -name "${class_name}.java" | head -n 1)

if [ -z "$java_file_path" ]; then
    echo "Java file for class ${class_name} not found."
    exit 1
else
    echo "Java file found at: $java_file_path"
fi

if [ -f "generate_diff.py" ]; then
    if [[ "$2" == GPT* ]]; then
        python3 generate_diff.py "$class_name" "$java_file_path" "$2" "$3"
    elif [[ "$2" == DeepSeek* || "$2" == Qwen* ]]; then
        python3 generate_diff.py "$class_name" "$java_file_path" "$2"
    else
        echo "Unsupported model. Not applying patches."
    fi
elif [ -f "../../../generate_diff.py" ]; then
    if [[ "$2" == GPT* ]]; then
        python3 ../../../generate_diff.py "$class_name" "$java_file_path" "$2" "$3"
    elif [[ "$2" == DeepSeek* || "$2" == Qwen* ]]; then
        python3 ../../../generate_diff.py "$class_name" "$java_file_path" "$2"
    else
        echo "Unsupported model. Not applying patches."
    fi
else
    echo "Error: generate_diff.py not found in either the current directory or ../../../"
    exit 1
fi

if [ -f "${class_name}.diff" ]; then
    echo -e "\n" >> "${class_name}.diff"
    tr -d '\r' < "${class_name}.diff" > "${class_name}_cleaned.diff"
    patch "$java_file_path" < "${class_name}_cleaned.diff"
    echo "Patch applied to $java_file_path"
else
    echo "Diff file not generated."
fi
