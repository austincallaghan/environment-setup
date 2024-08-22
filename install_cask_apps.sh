#!/bin/bash
source ./utils.sh

cask_applications=(
    "firefox,Firefox"
    "datagrip,Datagrip"
    "visual-studio-code,Visual Studio Code"
    "google-chrome,Google Chrome"
    "jetbrains-toolbox,JetBrains Toolbox"
    "microsoft-teams,Microsoft Teams"
    "postman,Postman"
    "docker,Docker"
    "iterm2,iTerm"
    "notion,Notion"
    "sublime-text,Sublime Text"
    "alfred,Alfred"
)

# Use iTerm in Alfred: curl --silent 'https://raw.githubusercontent.com/vitorgalvao/custom-alfred-iterm-scripts/master/custom_iterm_script.applescript' | pbcopy

# Function to prompt user for installation
prompt_install_app() {
    local app="$1"
    local gui_name="$2"
    if [ -d "/Applications/$gui_name.app" ]; then
        print_orange "$gui_name is already installed. Skipping."
    else
        if [ "$(prompt_yes_no "Do you want to install $gui_name?")" = "true" ]; then
            print_green "Installing $gui_name"
            brew install --cask "$app" --force || log_error "Failed to install $gui_name"
        else
            print_orange "Skipping installation of $gui_name."
        fi
    fi
}

# Prompt user and install GUI applications
for app_info in "${cask_applications[@]}"; do
    IFS=',' read -r app gui_name <<< "$app_info"
    prompt_install_app "$app" "$gui_name"
done

print_green "Setup complete!"
