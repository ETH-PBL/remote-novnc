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


---

## **GPU acceleration with VirtualGL (NEEDS SUDO)**
Sometimes you may want to run 3D applications inside the remote desktop with GPU acceleration. This can be achieved using [VirtualGL](https://virtualgl.org/), which redirects OpenGL commands from the remote X server to the host GPU.

### If you have a physical monitor plugged in
If you have already a monitor connected to the server with NVIDIA drivers installed, follow these steps:

1. Identify `<your GPU display no.>` and ensure that the monitor is rendering with the NVIDIA GPU. You can verify this by running:
   ```bash
   DISPLAY=<your GPU display> glxinfo | grep renderer
   ```
   It should show the NVIDIA GPU as the renderer and not llvmpipe or similar.

2. Install `vglrun` where you need to run the graphical application (for example only in a container):
   ```bash
   sudo wget https://github.com/VirtualGL/virtualgl/releases/download/3.1.4/virtualgl_3.1.4_amd64.deb && \
      sudo dpkg -i virtualgl_3.1.4_amd64.deb && \
      sudo rm virtualgl_3.1.4_amd64.deb
   ```
   Notice that a specific version is hardcoded, feel free to change it (check on github for newer releases). It is not on default repos for apt (anymore) at the moment of writing.

3. Start your normal Xfce session:
   ```bash
   ./start_vnc.sh
   ```
   Note down the noVNC display number shown in the output!!

4. When launching a normal OpenGL application that wants GPU accelerataion, prefix the command with `vglrun -d <your GPU display no.>`, e.g.:
   ```bash
   vglrun -d <your GPU display no.> rviz2
   ```
   you might actually need the VGL_DISPLAY variable set too, just run:
   ```bash
   VGL_DISPLAY=<your noVNC display> vglrun -d <your GPU display no.> rviz2
   ```
---

### Headless NVIDIA GPU setup (if you don't have a physical monitor plugged in)
Sometimes you may not have a physical monitor connected to your server. That's fine too, follow as below to setup a headless Xorg server with NVIDIA drivers:

1. Create a new Xorg configuration for a headless display:
   ```bash
   sudo nvidia-xconfig \
      --allow-empty-initial-configuration \
      --use-display-device=None \
      --virtual=1920x1080 \
      --busid=$(nvidia-xconfig --query-gpu-info | grep 'BusID' | head -n1 | awk '{print $4}')
   ```
   Change resolution if you wish. This will create/modify `/etc/X11/xorg.conf` which is needed for VirtualGL to work.
2. Start a headless Xorg server on an unused display, e.g. `:99`:
   ```bash
   sudo Xorg :99 -config /etc/X11/xorg.conf vt8
   ```
   You can verify that the Xorg server is running with:
   ```bash
   DISPLAY=:99 glxinfo | grep renderer
   ```
   It should show your NVIDIA GPU as the renderer.

   Follow now the steps in the **GPU acceleration with VirtualGL** section above, using `:99` as `<your GPU display no.>`.
