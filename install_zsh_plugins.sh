#!/bin/bash
source ./utils.sh

print_blue "Installing Zsh plugins..."

# Terminal Style: https://github.com/sindresorhus/iterm2-snazzy
# Terminal Theme: https://github.com/sindresorhus/pure


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

        print_green "Plugins installed successfully."
        print_blue "Please run 'source ~/.zshrc' to apply the changes."
    else
        print_orange "Skipping Zsh plugin installation."
    fi
}

prompt_install_zsh_plugins