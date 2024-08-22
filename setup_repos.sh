#!/bin/bash
source ./utils.sh

set -e

promptPrepareReposNow() {
    prepare_available_repos=$(prompt_yes_no "Would you like to setup (Run 'volta setup', 'yarn', and 'yarn bootstrap:env') in all applicable invitationhomes repos now? (Depending on your connection speed this can take 7-14 minutes.)")
    if [ "$prepare_available_repos" = "true" ]; then
        for currentRepo in "${repos_to_setup[@]}"; do
        # Run Volta Setup, yarn, and yarn bootstrap:env when applicable
        setup_if_possible "$currentRepo"
        done

    else
        print_orange "Skipping repo setup. If you would like to run setup later simple rerun this script. "
    fi
}

# List of any repos you would like to setup immediately, meaning run 'volta setup', 'yarn', 'yarn bootstrap:env'. 
repos_to_setup=(
    "atlas"
    "auth-client-package"
    "crucible"
    "email-templates-package"
    "google-ads"
    "insidemaps-client-package"
    "jira-git-cli"
    "marketing-admin"
    "photo-ordering-service"
    "photo-ingestion-scripts"
    "planomatic-service"
    "property-listing"
    "property-listing-website"
    "queue-client-package"
    "self-show"
    # "smarthome"
    "smartrent-service"
    "smartrent-client-package"
    "styled-ui-theme-ih-package"
    "styled-ui-package"
    "svelte-ui"
    # "sveltekit-template"
    "sveltekit-logger-package"
)

setup_if_possible() {
    local repo_name="$1"
    local repo_path="$DESTINATION/$repo_name"
    local package_json="$repo_path/package.json"

    if [ ! -d "$repo_path" ]; then
        print_orange "Directory $repo_path does not exist. Skipping repo."
        return
    fi

    if [ -f "$package_json" ]; then
        print_blue "Found package.json in $repo_path"

        cd "$repo_path"

        # Check if "volta" is in package.json
        if grep -q '"volta"' "$package_json"; then

            print_blue "Installing node and yarn using volta..."
            volta setup
            volta install node
            yarn
        fi

        # Check if "bootstrap:env" script is defined in package.json
        if grep -q '"bootstrap:env"' "$package_json"; then
            print_blue "Running yarn bootstrap:env..."
            yarn bootstrap:env
        fi

        cd ".."
    else
        print_orange "No package.json found in $repo_path. Skipping setup."
    fi
}

promptPrepareReposNow