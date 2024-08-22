#!/bin/bash

set -e

# Color variables
NC='\033[0m'
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
ORANGE='\033[0;33m'

# Packages to install
packages=(
    "git"
    "gh"
    "awscli"
    "volta"
    "zsh"
    "vim"
)

# Cask applications to install
cask_applications=(
    "firefox,Firefox"
    "datagrip,Datagrip"
    "visual-studio-code,Visual Studio Code"
    "google-chrome,Google Chrome"
    "jetbrains-toolbox,JetBrains Toolbox"
    "microsoft-teams,Microsoft Teams"
    "postman,Postman"
    "docker,Docker Desktop"
    "iterm2,iTerm"
    "notion,Notion"
    "sublime-text,Sublime Text"
)

# VSCode extensions to install
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

# Function to install VSCode extensions
prompt_vscode_extensions() {
    if [ "$(prompt_yes_no 'Would you like to install suggested VSCode extensions?')" = "true" ]; then
        for extension in "${vscode_extensions[@]}"; do
            code --install-extension "$extension" || print_red "Failed to install VSCode extension $extension"
        done
    else
        print_orange "Skipping VSCode Extension installation."
    fi
}

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

# Function to install Oh My Zsh
prompt_install_omz() {
    if [ "$(prompt_yes_no 'Would you like to install oh-my-zsh?')" = "true" ]; then
        if [ -d "$HOME/.oh-my-zsh" ]; then
            print_orange "Oh My Zsh is already installed. Skipping installation."
        else
            sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || log_error "Failed to install Oh My Zsh."
            chsh -s "$(which zsh)" || log_error "Failed to set Zsh as default shell."
        fi
    else
        print_orange "Skipping Oh My Zsh installation."
    fi
}

# Function to install Zsh plugins
prompt_install_zsh_plugins() {
    if [ "$(prompt_yes_no 'Would you like to install the following Zsh plugins: zsh-autosuggestions, zsh-syntax-highlighting and zsh-autocomplete?')" = "true" ]; then
        if ! grep -q "export ZSH_CUSTOM=" ~/.zshrc; then
            echo 'export ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"' >> ~/.zshrc
        fi

        export ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"

        clone_repo_if_not_exists "https://github.com/zsh-users/zsh-autosuggestions.git" "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
        clone_repo_if_not_exists "https://github.com/zsh-users/zsh-syntax-highlighting.git" "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
        clone_repo_if_not_exists "https://github.com/marlonrichert/zsh-autocomplete.git" "$ZSH_CUSTOM/plugins/zsh-autocomplete"

        sed -i '' 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting zsh-autocomplete)/g' ~/.zshrc

        print_green "Please run 'source ~/.zshrc' to apply the changes."
    else
        print_orange "Skipping Zsh plugin installation."
    fi
}

# Function to install command-line packages using Homebrew
install_package_with_brew() {
    local package="$1"
    print_green "Installing $package"
    brew install "$package" || log_error "Failed to install $package"
}

# Function to install GUI applications using Homebrew Cask
install_app_with_brew() {
    local app="$1"
    local gui_name="$2"
    if [ -d "/Applications/$gui_name.app" ]; then
        print_orange "$gui_name is already installed. Skipping."
    else
        print_green "Installing $gui_name"
        brew install --cask "$app" --force || log_error "Failed to install $gui_name"
    fi
}

# Function to clone a repository if it does not exist
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

print_blue "Beginning development environment setup..."

# Install Homebrew if not installed
if ! [ -x "$(command -v brew)" ]; then
    print_green "Installing Homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || log_error "Failed to install Homebrew"
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Install Heroku CLI if not installed
if ! [ -x "$(command -v heroku)" ]; then
    print_green "Installing Heroku CLI"
    brew tap heroku/brew 
    brew install heroku || log_error "Failed to install Heroku CLI"
fi

# Install command-line packages
for package in "${packages[@]}"; do
    install_package_with_brew "$package"
done

# Install GUI applications
for app_info in "${cask_applications[@]}"; do
    IFS=',' read -r app gui_name <<< "$app_info"
    install_app_with_brew "$app" "$gui_name"
done

# Prompt for VSCode setup if it is in the list of applications to install
if grep -q "visual-studio-code,Visual Studio Code" <<< "$(printf '%s\n' "${cask_applications[@]}")"; then
    prompt_vscode_extensions
    prompt_vscode_command_code
else
    print_orange "Visual Studio Code is not in the list of applications to install. Skipping VSCode setup."
fi

# Prompt for Zsh setup if it is in the list of packages to install
if grep -q "zsh" <<< "$(printf '%s\n' "${packages[@]}")"; then
    prompt_install_omz
else
    print_orange "Zsh is not in the list of packages to install. Skipping Zsh setup."
fi

# Prompt for Zsh plugin setup if .oh-my-zsh directory exists
if [ -d "$HOME/.oh-my-zsh" ]; then
    prompt_install_zsh_plugins
else
    print_orange "Oh My Zsh is not installed. Skipping Zsh plugin setup."
fi

print_green "Setup complete!"
