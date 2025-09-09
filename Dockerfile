FROM ubuntu:22.04
WORKDIR /novnc
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install iproute2 dbus novnc x11vnc xvfb xfce4 xfce4-goodies dnsutils -y
ADD start_vnc.sh /start_vnc.sh
RUN chmod +x /start_vnc.sh
WORKDIR /log
CMD ["/start_vnc.sh"]