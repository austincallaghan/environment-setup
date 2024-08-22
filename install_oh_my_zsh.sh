#!/bin/bash
source ./utils.sh


# Function to install Oh My Zsh
prompt_install_omz() {
    if [ "$(prompt_yes_no 'Would you like to install oh-my-zsh?')" = "true" ]; then
        if [ -d "$HOME/.oh-my-zsh" ]; then
            print_orange "Oh My Zsh is already installed. Skipping installation."
        else
            print_blue "Installing Oh My Zsh..."
            sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || log_error "Failed to install Oh My Zsh."
            chsh -s "$(which zsh)" || log_error "Failed to set Zsh as default shell."

            source ~/.zshrc
        fi
    else
        print_orange "Skipping Oh My Zsh installation."
    fi
}

prompt_install_omz