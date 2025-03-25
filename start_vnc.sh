#! /bin/bash

exec supervisord -c  "$HOME/catkin_ws/src/race_stack/.devcontainer/.vnc_utils/supervisord.conf"
