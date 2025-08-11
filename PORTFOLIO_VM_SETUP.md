# Portfolio VM Setup Guide

## Overview
This is a stripped-down WebVM implementation that runs Linux in the browser with root access, perfect for showcasing Linux applications in your portfolio.

## Installation

1. Install dependencies:
```bash
npm install
```

2. Start development server:
```bash
npm run dev
```

3. Build for production:
```bash
npm run build
```

## Adding Your Linux Programs

### Method 1: Direct File Upload (Recommended for Development)
1. Start the VM and get root access
2. Use the terminal to create directories: `mkdir -p /usr/local/myapps`
3. Upload your compiled binaries using the browser's drag-and-drop or copy-paste functionality
4. Make them executable: `chmod +x /usr/local/myapps/your-program`
5. Add to PATH: `echo 'export PATH=/usr/local/myapps:$PATH' >> /root/.bashrc`

### Method 2: Build a Custom Disk Image
For permanent integration of your applications:

1. Create a Dockerfile extending the base WebVM image:
```dockerfile
FROM debian:bookworm-slim
# Install your applications
COPY your-app /usr/local/bin/
RUN chmod +x /usr/local/bin/your-app
# Add any dependencies
RUN apt-get update && apt-get install -y your-dependencies
```

2. Build and convert to ext2 format using WebVM tools
3. Update `config_terminal.js` with your custom disk image URL

### Method 3: Runtime Installation
Use the VM's package manager to install tools:
```bash
# Update package lists
apt update

# Install your preferred tools
apt install -y gcc python3 nodejs npm

# Install your applications from source
git clone https://github.com/your-username/your-app
cd your-app
make install
```

## VM Configuration

### Root Access
The VM is configured for root access by default in `config_terminal.js`:
- `uid: 0` - Root user ID
- `gid: 0` - Root group ID
- `HOME=/root` - Root home directory

### Customization Options

#### Terminal Configuration
Edit `config_terminal.js` to modify:
- `diskImageUrl` - Change the base Linux image
- `cmd` and `args` - Modify the default shell
- `env` - Set environment variables

#### UI Customization
Edit `src/lib/WebVM.svelte` to customize:
- Terminal appearance
- Header content
- Control buttons
- Styling

## Hosting on GitHub Pages

### Automatic Deployment
The project is configured for automatic GitHub Pages deployment:

1. Push your code to GitHub
2. GitHub Actions will automatically build and deploy
3. Your VM will be available at `https://username.github.io/repository-name`

### Manual Deployment
Alternatively, you can deploy manually:
```bash
npm run build
npm run gh-pages
```

### GitHub Pages Setup
1. Go to your repository Settings
2. Navigate to Pages section
3. Select "GitHub Actions" as the source
4. The workflow will handle the rest

**Note**: GitHub Pages has limitations with SharedArrayBuffer support, so some WebVM features may not work. For full functionality, consider alternative hosting options like Netlify or Vercel.

## Demo Ideas for Portfolio

### Showcasing Applications
1. **Command-line tools**: Display help output, run examples
2. **Development environments**: Show code compilation and execution
3. **System utilities**: Demonstrate file operations, process management
4. **Network tools**: Show connectivity testing, protocol implementations

### Interactive Demonstrations
1. Create shell scripts that run your programs with sample inputs
2. Set up aliases for quick access: `alias myapp='cd /usr/local/myapps && ./myapp'`
3. Create a welcome script that introduces visitors to your tools
4. Add README files in `/root/` explaining each application

## Troubleshooting

### SharedArrayBuffer Issues
If you get SharedArrayBuffer errors, ensure your hosting provider supports COOP/COEP headers.

### Performance Issues
- Use WebSocket disk images when available (`wss://` URLs)
- Consider smaller base images for faster loading
- Implement caching strategies for frequently accessed files

### File Persistence
Files created in the VM are temporary. For persistent demonstrations:
1. Include sample files in your custom disk image
2. Use the reset functionality to return to a clean state
3. Create initialization scripts that set up your demo environment

## Next Steps

1. Test your VM locally with `npm run dev`
2. Add your applications using one of the methods above
3. Customize the UI to match your portfolio theme
4. Deploy to your preferred hosting platform
5. Create engaging demonstrations of your Linux programs

## Support

For WebVM-specific issues, refer to the original WebVM documentation.
For portfolio integration questions, check the issues in your project repository.