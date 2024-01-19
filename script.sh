#!/bin/bash

# One night project no.3
# Bash AI helper

# Features:
# - can help you to write commands, even if you forgot or messed up syntax

# Requirements:
# - curl

# Author: @roboT-23
# Version: 0.1
# Date: 2024-01-19
# License: MIT


command_not_found_handle() {

echo "Error: '$formatted' Command doesn't exist."
    local choice=""
    read -p "Do you want quick tip? (Y/N): " choice
    [[ -z "$choice" ]] && choice="Y"
    case $choice in
        [Yy])
	    # Call OpenAI API
	    local input="$*"
	    local formatted=""
	    local arg

	  # Loop over each argument in the input string
	  for arg in $input; do
	    # If the argument contains spaces, enclose it in quotes
	    if [[ $arg == *[[:space:]]* ]]; then
	      arg="\"$arg\""
	    fi

	    # Append the argument to the formatted string
	    formatted+="$arg "
	  done
	  
	  local api_URL="YOUR_API_URL"
	  local api_key="YOUR_API_KEY"
	  # Remove the trailing space
	  formatted=${formatted%?}
	  local response=$(curl -s  --request POST \
	     --url "$api_URL" \
	     --header "Authorization: Bearer $api_key" \
	     --header 'accept: application/json' \
	     --header 'content-type: application/json' \
	     --data "{\"model\":\"gpt-3.5-turbo\", \"max_tokens\": 100,\"temperature\": 0.7,\"messages\": [{\"role\": \"user\",\"content\": \"you are a linux shell. She said '$formatted' to you. If she wants to chat with you just answer her, if it seems like she used the wrong command just tell her the correct one. Write ONLY right command, and simple description.\"}],\"stream\": false}")

	    # Parse the response and echo the generated text

	    local generated_text=$(echo $response | jq -r '.choices[0].message.content')

	    echo '---answer---'
	    echo -e "\033[36m$generated_text\033[0m"
	return 127
            ;;
        [Nn])
            echo "Okey-dokey, bye then."
            return 0
            ;;
        *)
            echo "Invalid choice, bye"
            return 0
            ;;
    esac
   
}
export -f command_not_found_handle
