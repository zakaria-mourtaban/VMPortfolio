FROM alpine:latest

# Install packages
RUN apk update && apk add --no-cache \
    xfce4 \
    xfce4-terminal \
    xfce4-screensaver \
    xvfb \
    x11vnc \
    dbus \
    dbus-x11 \
    ttf-dejavu \
    firefox \
    sudo \
    bash \
    procps \
    xauth \
    xrdb \
    xwininfo \
    && rm -rf /var/cache/apk/*

# Create a user
RUN adduser -D -s /bin/bash vncuser && \
    echo "vncuser:password" | chpasswd && \
    adduser vncuser wheel && \
    echo '%wheel ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Switch to the user
USER vncuser
WORKDIR /home/vncuser

# Create VNC directory and password
RUN mkdir -p ~/.vnc && \
    x11vnc -storepasswd password ~/.vnc/passwd

# Create the startup script
RUN echo '#!/bin/bash' > ~/start-vnc.sh && \
    echo '' >> ~/start-vnc.sh && \
    echo '# Kill any existing X server' >> ~/start-vnc.sh && \
    echo 'pkill -f "Xvfb\|x11vnc\|xfce4" 2>/dev/null || true' >> ~/start-vnc.sh && \
    echo '' >> ~/start-vnc.sh && \
    echo '# Start D-Bus' >> ~/start-vnc.sh && \
    echo 'sudo mkdir -p /run/dbus' >> ~/start-vnc.sh && \
    echo 'sudo dbus-daemon --system --fork --nopidfile' >> ~/start-vnc.sh && \
    echo '' >> ~/start-vnc.sh && \
    echo '# Start X virtual framebuffer on display :1' >> ~/start-vnc.sh && \
    echo 'echo "Starting Xvfb..."' >> ~/start-vnc.sh && \
    echo 'Xvfb :1 -screen 0 1024x768x24 -ac +extension GLX +render -noreset &' >> ~/start-vnc.sh && \
    echo 'XVFB_PID=$!' >> ~/start-vnc.sh && \
    echo 'sleep 2' >> ~/start-vnc.sh && \
    echo '' >> ~/start-vnc.sh && \
    echo '# Set display' >> ~/start-vnc.sh && \
    echo 'export DISPLAY=:1' >> ~/start-vnc.sh && \
    echo '' >> ~/start-vnc.sh && \
    echo '# Start XFCE4 desktop' >> ~/start-vnc.sh && \
    echo 'echo "Starting XFCE4..."' >> ~/start-vnc.sh && \
    echo 'dbus-launch --exit-with-session startxfce4 &' >> ~/start-vnc.sh && \
    echo 'XFCE_PID=$!' >> ~/start-vnc.sh && \
    echo 'sleep 5' >> ~/start-vnc.sh && \
    echo '' >> ~/start-vnc.sh && \
    echo '# Wait for XFCE to be ready' >> ~/start-vnc.sh && \
    echo 'echo "Waiting for desktop to initialize..."' >> ~/start-vnc.sh && \
    echo 'while ! xwininfo -root -tree > /dev/null 2>&1; do sleep 1; done' >> ~/start-vnc.sh && \
    echo '' >> ~/start-vnc.sh && \
    echo '# Start VNC server' >> ~/start-vnc.sh && \
    echo 'echo "Starting VNC server on display :1 (port 5901)..."' >> ~/start-vnc.sh && \
    echo 'x11vnc -display :1 -forever -usepw -rfbport 5901 -shared &' >> ~/start-vnc.sh && \
    echo 'VNC_PID=$!' >> ~/start-vnc.sh && \
    echo '' >> ~/start-vnc.sh && \
    echo 'echo "═══════════════════════════════════════════════════════════"' >> ~/start-vnc.sh && \
    echo 'echo "  VNC Server is ready!"' >> ~/start-vnc.sh && \
    echo 'echo "  Connect to: localhost:5901"' >> ~/start-vnc.sh && \
    echo 'echo "  Password: password"' >> ~/start-vnc.sh && \
    echo 'echo "═══════════════════════════════════════════════════════════"' >> ~/start-vnc.sh && \
    echo '' >> ~/start-vnc.sh && \
    echo '# Keep container running' >> ~/start-vnc.sh && \
    echo 'wait' >> ~/start-vnc.sh && \
    chmod +x ~/start-vnc.sh

# Expose VNC port
EXPOSE 5901

# Start VNC server
CMD ["./start-vnc.sh"]