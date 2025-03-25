#! /bin/bash

sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get install supervisor novnc x11vnc xvfb xfce4 xfce4-goodies -y

# use current folder
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "" >> ~/.bashrc
echo "export VNC_DIR=\"$SCRIPT_DIR\"" >> ~/.bashrc

