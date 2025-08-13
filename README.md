# Alpine Linux VNC Container Instructions

## Build the Container

1. Save the Dockerfile to a directory
2. Build the container:
```bash
docker build -t alpine-vnc .
```

## Run the Container

```bash
docker run -d -p 5901:5901 --name alpine-desktop alpine-vnc
```

## Connect via VNC

### Option 1: VNC Viewer
1. Install a VNC viewer (like TigerVNC Viewer, RealVNC, or TightVNC)
2. Connect to `localhost:5901` or `127.0.0.1:5901`
3. Use password: `password`

### Option 2: Web Browser (if you want web access)
To add web VNC access, you can extend the container with noVNC:

```bash
# Stop the current container
docker stop alpine-desktop
docker rm alpine-desktop

# Run with additional port for web VNC (requires modified Dockerfile)
docker run -d -p 5901:5901 -p 6080:6080 --name alpine-desktop alpine-vnc
```

## Default Credentials
- VNC Password: `password`
- User: `vncuser`
- User Password: `password` (for sudo access)

## Customization Options

### Change VNC Password
Before building, modify the Dockerfile line:
```bash
echo "your_new_password" | vncpasswd -f > ~/.vnc/passwd
```

### Change Screen Resolution
Modify the geometry in the startup script:
```bash
vncserver :1 -geometry 1920x1080 -depth 24
```

### Add More Software
Add packages to the `apk add` command in the Dockerfile:
```bash
RUN apk update && apk add --no-cache \
    xfce4 \
    xfce4-terminal \
    tigervnc \
    # ... existing packages ...
    vim \
    git \
    python3 \
    nodejs \
    npm
```

## Useful Commands

### Check container logs
```bash
docker logs alpine-desktop
```

### Stop the container
```bash
docker stop alpine-desktop
```

### Restart the container
```bash
docker restart alpine-desktop
```

### Access container shell
```bash
docker exec -it alpine-desktop bash
```

## Troubleshooting

### VNC Server Won't Start
- Check logs: `docker logs alpine-desktop`
- Ensure port 5901 isn't already in use: `netstat -an | grep 5901`

### Can't Connect to VNC
- Verify container is running: `docker ps`
- Check port mapping: `docker port alpine-desktop`
- Try connecting to `localhost:1` instead of `localhost:5901`

### Desktop Environment Issues
- Restart the container: `docker restart alpine-desktop`
- Check if dbus service is running inside container