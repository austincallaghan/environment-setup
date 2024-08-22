#!/bin/bash
source ./utils.sh

# Function to install 'code .' command for VSCode
prompt_vscode_command_code() {
    if [ "$(prompt_yes_no 'Would you like to install \"code .\" command for VSCode?')" = "true" ]; then
        if [ ! -L /usr/local/bin/code ]; then
            sudo ln -s "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code" /usr/local/bin/code || log_error "Failed to create symbolic link for VSCode command."
            print_green "Symbolic link created successfully. You can now use 'code .' to open a folder/file in VSCode."
        else
            print_orange "Symbolic link /usr/local/bin/code already exists. Skipping."
        fi 
    else
        print_orange "Skipping VSCode 'code .' command installation."
    fi
}

prompt_vscode_command_code