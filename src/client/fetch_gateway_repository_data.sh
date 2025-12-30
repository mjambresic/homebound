#!/bin/bash
source "$(dirname "$(realpath "$0")")/../shared.sh"

# Variables
LOCAL_REPO_PATH="$ROOT_DIRECTORY/sync_data"

printf "\nUpdating local files.\n"

# Fetch changes from the remote repository
git -C $LOCAL_REPO_PATH fetch origin

# Check if the fetch was successful
if [ $? -ne 0 ]; then
    printf "${RED}Failed to fetch data from the gateway repository. Make sure you set up git repository properly, or check your internet connection.\n${RESET}"
    exit 1
fi

# Force reset to the remote branch
git -C $LOCAL_REPO_PATH reset --hard origin/main

# Check if the reset was successful
if [ $? -eq 0 ]; then
    printf "${GREEN}Data was successfully synced from the gateway repository.${RESET}\n"

    # Connection Data
    externalIp=$(get_stored_external_ip)
    user=$(get_stored_user)
    host=$(get_stored_host)

    printf "External IP: ${YELLOW}%s${RESET}\n" "$externalIp"
    printf "User: ${YELLOW}%s${RESET}\n" "$user"
    printf "Host: ${YELLOW}%s${RESET}\n" "$host"
else
    printf "${RED}Failed to sync data from the gateway repository.${RESET}\n"
fi
