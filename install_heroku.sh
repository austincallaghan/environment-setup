#!/bin/bash
source ./utils.sh

# Install Heroku CLI if not installed
if ! [ -x "$(command -v heroku)" ]; then
    print_blue "Installing Heroku CLI..."
    brew tap heroku/brew 
    brew install heroku || log_error "Failed to install Heroku CLI"
else
    print_orange "Heroku CLI is already installed. Skipping."
fi