# **Remote GUI Access with noVNC**

noVNC provides a browser-based VNC client, enabling seamless access to a remote Linux desktop environment. It allows users to run graphical applications on a headless server or a virtualized environment while interacting with them through a web browser. This setup eliminates the need for a local X server and provides a smooth remote desktop experience.

This setup is particularly useful for:

- **MacOS users**: Running `rviz` and other GUI applications that require OpenGL, which macOS does not support.
- **WSL (Windows Subsystem for Linux) users**: Accessing a full desktop environment within WSL2.
- **Remote Access**: Connecting securely to a remote machine via **SSH tunneling**.

This system leverages:
- **Xvfb**: A virtual framebuffer to create a headless display (`:1`).
- **Xfce4**: A lightweight Linux desktop environment.
- **x11vnc**: A VNC server for remote access.
- **noVNC & websockify**: A web-based VNC client for browser-based access.

---

## **Setup Instructions**

### **1️⃣ Setup VNC**
Run the setup script:
```bash
./setup_vnc.sh
```
This will install all dependencies (if you are sudo) and prompt you to set up a VNC password.
If you are on mac this will be setup in docker container. For this you need to install [docker](https://www.docker.com/get-started). 

### **2️⃣ Start VNC**
Run:
```bash
./start_vnc.sh
```
This should output something like:
```
Started VNC DISPLAY=:1001 SCREEN=10
Local VNC: localhost:11001
Remote NoVNC: http://server-name.ee.ethz.ch:21001/vnc.html
```
#### Configs
Pass a resolution or the name of a config in `configs/`:
```bash
./start_vnc.sh 1500x830   # explicit resolution
./start_vnc.sh big        # sources configs/big.conf
```
A config is a sourced shell file that may set `RESOLUTION` and `FORCE_DOCKER`. Add your own as `configs/<name>.conf`.

#### Force Docker
Docker is used automatically on macOS. To use it on any machine, set `FORCE_DOCKER=1` (env or config) for both scripts:
```bash
FORCE_DOCKER=1 ./setup_vnc.sh
FORCE_DOCKER=1 ./start_vnc.sh big
```

The port is derived based on your UID, thus it will likely be different to what is written in this README!


⚠ **Keep this terminal open** – closing it with `Ctrl-C` will stop the VNC session.

---

## **Accessing the Remote Desktop**

### **🔹 Local Access (MacOS / WSL)**
If you are running noVNC on your local machine inside WSL or a Docker container:

1. Open a browser and go to:
   ```
   http://server-name.ee.ethz.ch:21001/vnc.html
   ```
2. You should now see the remote Linux desktop.


