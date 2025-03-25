#! /bin/bash

sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get install supervisor novnc x11vnc xvfb xfce4 xfce4-goodies -y
echo 'export DISPLAY=:1' >> ~/.bashrc
echo 'export VNC_DIR="$HOME/catkin_ws/src/race_stack/.devcontainer/.vnc_utils"' >> ~/.bashrc

