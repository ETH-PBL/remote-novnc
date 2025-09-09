#! /bin/bash

BOLD="\033[1m"
END_BOLD="\033[0m"

if [[ "$(uname)" == "Darwin" ]]; then
  echo "Running on macOS, building with Docker"
  docker build -t novnc .
  exit 1
fi

# use current folder
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
USER_SHELL=$(basename "$SHELL")



# Install Dependencies
if groups "$USER" | grep -q '\bsudo\b'; then
  echo -e "${BOLD}Installing Dependencies....${END_BOLD}"
  sudo apt-get update
  sudo DEBIAN_FRONTEND=noninteractive apt-get install supervisor novnc x11vnc xvfb xfce4 xfce4-goodies -y
else
  echo "User is NOT in the sudo group, skipping installing dependencies."
fi


# Set up VNC password
echo -e "\n${BOLD}Set up VNC password${END_BOLD}"
x11vnc -storepasswd

