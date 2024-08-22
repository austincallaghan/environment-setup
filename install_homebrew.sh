#!/bin/bash
source ./utils.sh

# Install Homebrew if not installed
if ! [ -x "$(command -v brew)" ]; then
    print_blue "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || log_error "Failed to install Homebrew"
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    print_orange "Homebrew is already installed. Skipping."
fi