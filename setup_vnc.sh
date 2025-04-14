#! /bin/bash

BOLD="\033[1m"
END_BOLD="\033[0m"

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



# Add the export command to the appropriate config file
echo -e "${BOLD}Finalizing...${END_BOLD}"
case "$USER_SHELL" in
  bash)
    echo -e "\nexport VNC_DIR=\"$SCRIPT_DIR\"" >> ~/.bashrc
    echo "Dont forget to source ~/.bashrc"
    ;;
  zsh)
    echo -e "\nexport VNC_DIR=\"$SCRIPT_DIR\"" >> ~/.zshrc
    echo "Dont forget to source ~/.zshrc"
    ;;
  fish)
    # In Fish, use `set -x` for exporting environment variables
    echo -e "\nset -x VNC_DIR \"$SCRIPT_DIR\"" >> ~/.config/fish/config.fish
    ;;
  *)
    echo "Unsupported shell: $USER_SHELL. Please add 'VNC_DIR=\"$SCRIPT_DIR\"' to your shell config manually."
    ;;
esac
