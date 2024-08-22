#!/bin/bash
source ./utils.sh

print_blue "Beginning development environment setup..."

./install_homebrew.sh
./install_heroku.sh
./install_packages.sh
./install_cask_apps.sh
./install_oh_my_zsh.sh
./install_vscode_extensions.sh
./install_zsh_plugins.sh
./setup_code_dot_vscode_command.sh

print_green "Environment setup complete!"
