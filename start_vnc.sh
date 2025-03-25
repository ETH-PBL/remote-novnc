#! /bin/bash

export DISPLAY=:123
exec supervisord -c  "$VNC_DIR/supervisord.conf"
