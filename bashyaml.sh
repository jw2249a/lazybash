#!/usr/bin/env bash

bashyaml() {
    local yaml_file="$1"
    shift
    declare -A args_map
    declare -A shift_values
    
    # Read YAML file and populate an associative array
    while IFS= read -r line; do
        if [[ "$line" == longargs:* ]]; then
            mode="long"
        elif [[ "$line" == shortargs:* ]]; then
            mode="short"
        fi
        
        if [[ "$line" =~ ^[[:space:]]*([^:]+):[[:space:]]*([[:alnum:]_-]+)[[:space:]]*(#.*)?$ ]]; then
            local key="${BASH_REMATCH[1]}"
            local value="${BASH_REMATCH[2]}"
            args_map[$key]=$value
            if  [[ $mode == "long" ]]; then
                shift_values[$key]=2
            elif [[ $mode == "short" ]]; then
                shift_values[$key]=1
            fi
            
        fi
    done < "$yaml_file"

    # Process command-line arguments
    while [[ $# -gt 0 ]]; do
        local arg=$1
        if [[ ${args_map[$arg]} ]]; then
            local func=${args_map[$arg]}
            if declare -f "$func" > /dev/null; then
                if [[ "${shift_values[$arg]}" == 2 ]] && [ -z ${2+x} ]; then
                    echo "$arg requires at least 1 argument"
                    exit 1
                fi
                
                $func "$@"
            else
                echo "Function $func not defined"
                exit 1
            fi
        else
            echo "Unknown option: $arg"
            exit 1
        fi
        
        shift "${shift_values[$arg]}"
    done
}

