#!/bin/bash
source ./utils.sh

# List of all relevant invitationhomes repos. Feel free to add/remove as necessary.
repos_to_clone=(
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
    "property-sync"
    "property-listing"
    "property-service"
    "property-listing-website"
    "queue-client-package"
    "self-show"
    "smarthome"
    "smartrent-service"
    "smartrent-client-package"
    "styled-ui-theme-ih-package"
    "styled-ui-package"
    "svelte-ui"
    "sveltekit-template"
    "sveltekit-logger-package"
    "technology-decisions"
)

# Ensure the destination directory exists
if [ ! -d "$DESTINATION" ]; then
  mkdir -p "$DESTINATION"
  print_green "Directory $DESTINATION created."
else
  print_orange "Directory $DESTINATION already exists."
fi

# Function to clone a repository if it doesn't already exist
clone_repo() {
    local repo_name="$1"

    if [ ! -d "$DESTINATION/$repo_name" ]; then
        print_blue "Cloning $INVH_GITHUB_SSH_PREFIX/$repo_name$INVH_GITHUB_SSH_SUFFIX to $DESTINATION/$repo_name"
        git clone "$INVH_GITHUB_SSH_PREFIX/$repo_name$INVH_GITHUB_SSH_SUFFIX" "$DESTINATION/$repo_name"
    else
        print_orange "Directory $DESTINATION/$repo_name already exists. Skipping clone."
    fi
}

# Iterate through the array of repositories and clone if they don't exist
for repo in "${repos_to_clone[@]}"; do
    clone_repo "$repo"
done