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
- **Supervisor**: Process management to ensure services run reliably.

In the `race_stack`, this functionality is integrated as a submodule inside the `.devcontainer` folder, but it can be used in a stand-alone way to connect to a graphical session also without the entire `race_stack`, just by cloning the code from the [main repo](https://git.ee.ethz.ch/pbl/research/f1tenth/remote-novnc-setup).

---

## **Setup Instructions**

### **1️⃣ Setup VNC**
Run the setup script:
```bash
./.devcontainer/.vnc_utils/setup_vnc.sh
```

### **2️⃣ Start VNC**
Run:
```bash
./.devcontainer/.vnc_utils/start_vnc.sh
```
⚠ **Keep this terminal open** – closing it will stop the VNC session.

---

## **Accessing the Remote Desktop**

### **🔹 Local Access (MacOS / WSL)**
If you are running noVNC on your local machine inside WSL or a Docker container:

1. Open a browser and go to:
   ```
   http://localhost:8080/vnc.html
   ```
2. You should now see the remote Linux desktop.

---

### **🔹 Remote Access via SSH Tunnel**
If you are connecting to a **remote machine**, ensure the initial setup is performed on that machine.

Once the setup is complete, on your **local machine**, run:
```bash
ssh -L 5901:localhost:5900 -L 8080:localhost:8080 <remote-user>@<remote-ip>
```
This command establishes a secure tunnel between your local machine and the remote machine, forwarding the necessary ports for VNC and noVNC access.

Now, access the VNC session at:
```
http://localhost:8080/vnc.html
```
