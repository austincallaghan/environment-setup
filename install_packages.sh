#!/bin/bash
source ./utils.sh

packages=(
    "git"
    "gh"
    "awscli"
    "volta"
    "zsh"
    "vim"
    "jq"
    "postgresql"
)

# Function to prompt user for installation
prompt_install_package() {
    local package="$1"
    if [ "$(prompt_yes_no "Do you want to install $package?")" = "true" ]; then
        print_blue "Installing $package..."
        brew install "$package" || log_error "Failed to install $package"
    else
        print_orange "Skipping installation of $package."
    fi
}

# Install command-line packages
for package in "${packages[@]}"; do
    prompt_install_package "$package"
done