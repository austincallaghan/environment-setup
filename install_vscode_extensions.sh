#!/bin/bash
source ./utils.sh

# VSCode Terminal Theme: https://github.com/Tyriar/vscode-snazzy/tree/master

vscode_extensions=(
    "dbaeumer.vscode-eslint"
    "eamodio.gitlens"
    "Orta.vscode-jest"
    "andys8.jest-snippets"
    "esbenp.prettier-vscode"
    "christian-kohler.path-intellisense"
    "ChakrounAnas.turbo-console-log"
    "wayou.vscode-todo-highlight"
    "svelte.svelte-vscode"
)

prompt_install_extension() {
    local extension="$1"
    if [ "$(prompt_yes_no "Do you want to install VSCode extension $extension?")" = "true" ]; then
        code --install-extension "$extension" || print_red "Failed to install VSCode extension $extension"
    else
        print_orange "Skipping installation of VSCode extension $extension."
    fi
}

for extension in "${vscode_extensions[@]}"; do
    prompt_install_extension "$extension"
done