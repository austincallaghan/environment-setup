#!/bin/bash

DESTINATION="$HOME/development"
INVH_GITHUB_SSH_PREFIX="git@github.com:invitation-homes"
INVH_GITHUB_SSH_SUFFIX=".git"

# Color variables
NC='\033[0m'
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
ORANGE='\033[0;33m'

# Function to print in color
print_green() { echo -e "${GREEN}$1${NC}"; }
print_red() { echo -e "${RED}$1${NC}"; }
print_blue() { echo -e "${BLUE}$1${NC}"; }
print_orange() { echo -e "${ORANGE}$1${NC}"; }

# Function to log error and exit
log_error() {
    print_red "$1"
    exit 1
}

# Function to prompt the user for yes/no input
prompt_yes_no() {
    local message="$1"
    local response
    while true; do
        read -r -p "$(print_blue "$message") (y/n): " response
        case "$response" in
            [yY][eE][sS]|[yY]) echo "true"; break ;;
            [nN][oO]|[nN]) echo "false"; break ;;
            *) print_red "Invalid input. Please enter y or n." ;;
        esac
    done
}


clone_repo_if_not_exists() {
    local repo_url="$1"
    local destination="$2"
    if [ ! -d "$destination" ]; then
        print_green "Cloning $repo_url to $destination"
        git clone "$repo_url" "$destination" || log_error "Failed to clone $repo_url"
    else
        print_orange "Directory $destination already exists. Skipping clone."
    fi
}