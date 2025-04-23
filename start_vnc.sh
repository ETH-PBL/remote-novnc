#! /bin/bash

USER_ID="${USER_ID:-$(id -u)}"  # Default to current user's ID if not set


# Get hostname one-liner :D
# - Grabs default route interface (eg. eno1)
# - Fetches the IP of the interface 192.168.x.x
# - uses nslookup to check what the NAC entry for that IP is on the network
# - Filter out stupid dot at the end
HOSTNAME=$(nslookup $(ip route show default | awk '{print $5}' | xargs -I {} ip addr show {} | grep 'inet ' | awk '{print $2}' | cut -d/ -f1 | head -n 1)  | grep -w 'name' | awk '{print $4}' | sed 's/\.$//')


if [ -z "$HOSTNAME" ]; then
    HOSTNAME=$(hostname)
fi

# Adjust DISPLAY and VNC_PORT based on USER_ID
export DISPLAY_NUM="$((1 + (USER_ID % 16)))"   # DISPLAY will be USER_ID % 16
export DISPLAY=":$USER_ID"
export VNC_PORT=$((10000 + USER_ID)) # VNC_PORT will be 10000 + USER_ID
export NOVNC_PORT=$((20000 + USER_ID)) # VNC_PORT will be 20000 + USER_ID

# Kill any lingering processes from before
pkill -u $USER_ID Xvfb
pkill -u $USER_ID xfce4-session
pkill -u $USER_ID websockify
pkill -u $USER_ID x11vnc

trap 'kill 0' SIGINT

echo "Starting DISPLAY=$DISPLAY VNC on http://$HOSTNAME:$NOVNC_PORT/vnc.html"

# Create new virtual frame buffer
Xvfb $DISPLAY -screen $DISPLAY_NUM 1920x1080x24 -listen tcp -ac &
XVFB_PID=$!

# Wait briefly to let it initialize
sleep 1

# Check if Xvfb is still running (i.e., it didn't crash)
if ! kill -0 $XVFB_PID 2>/dev/null; then
    echo "❌ Failed to start Xvfb on display $DISPLAY_NUM"
    exit 1
fi

# Start the XFCE4 session
echo "Starting XFCE4"
xfce4-session &>> xfce.log &

# Start the X11 VNC
echo "Starting X11"
x11vnc -display $DISPLAY -forever -shared -rfbport $VNC_PORT -usepw &>> x11.log &

# Start the webserver
echo "Starting Webserver"
websockify --web /usr/share/novnc $NOVNC_PORT localhost:$VNC_PORT &>> websockify.log &

wait


