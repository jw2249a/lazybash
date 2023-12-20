#!/usr/bin/env bash

# sample funs
display_help() { echo "Help:"; cat bash.yaml; }
multi_args_comment() { echo "You input this $2, see comment in yaml"; }
multi_args() { echo "You input this $2"; }

# Call the function with the path to the YAML file and all script arguments
bashyaml "bash.yaml" "$@"
