# Development Container Template - Just Git

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Docker](https://img.shields.io/badge/Docker-Required-blue)](https://www.docker.com/)
[![VS Code](https://img.shields.io/badge/VS%20Code-Required-blue)](https://code.visualstudio.com/)

## Why do I have this project?

In the last few years I have been using Visual Studio Code, and I like to use as much containers as I can, instead of setting up environments or things like that.

Devcontainers is pretty handy for that, and it is just a short step to move it into a deployment when I am done.

I found myself re creating a similar setup each time, with more or less features each time, and this is an attempt to simplify that step.

I am thinking of creating a few different devcontaienrs, each based in a previous iteration (although I don't like inheritance, in this case seems to be valuable).

This is the first run. Just Ubuntu (my remote deployments are usually containers based in Ubuntu) with git and some editing tools (Markdown validation, some git shortcuts, and that is it).

VS Code is also configured to use the validation tools by way of extensions, and they also hang as command line tools (although I don't use them regularly).

An extra situation is that I have also a Synology NAS where I synchronise my files. I commit to git when ready, but I like to be able to continue working in any of my machines and have them in sync automatically. Synology Drive is good for that.

However, there are some tricky cases around file ownership (I use Ubuntu 24.10 at the moment in my own machines). Depending on where the files are created (the workstation or inside the container), Synology gets confused and start to cause troubles around the synchronisation process.

A way around it is to use the same user inside the container as it is outside. A launch script takes care of that details passing activity, and all the files seems to be updated correctly now.

I want to be able to use Git inside and out of the container, then I also pass the ssh credentials to my Git remote repository to syncronise at will. That also seems to be working correctly.

### Development Tools

The development container comes with several pre-installed tools and features:

1. **Docker Integration**
   - Microsoft Docker extension (`ms-azuretools.vscode-docker`)
   - Full Docker CLI support
   - Container management and debugging capabilities
   - Integrated Docker Desktop support

2. **Modern Shell Experience**
   - Starship prompt
   - Custom-configured prompt with Git status
   - Fast and responsive command-line interface
   - Configurable via `starship.toml` in the config directory

3. **JSON Tools**
   - `jq` command-line JSON processor
   - VS Code extensions for JSON:
     - Prettier (`esbenp.prettier-vscode`) for formatting
     - ESLint (`dbaeumer.vscode-eslint`) for linting
   - Helpful aliases:
     - `jsonlint`: Format and validate JSON
     - `jsonformat`: Pretty print JSON
     - `jsonvalidate`: Check JSON syntax
     - `jsonpretty`: Format JSON with nice output

4. **Additional VS Code Extensions**
   - Markdown linting (`DavidAnson.vscode-markdownlint`)
   - Remote Containers support (`ms-vscode-remote.remote-containers`)

## Table of Contents

- [Quick Start](#quick-start)
- [Setting Up a New GitHub Project](#setting-up-a-new-github-project)
- [Usage](#usage)
  - [Requirements](#requirements)
  - [Basic Usage](#basic-usage)

- [Development Container Setup](#development-container-setup)
- [Customization](#customization)
- [Project Structure](#project-structure)
- [Troubleshooting](#troubleshooting)
- [Security Notes](#security-notes)
- [Contributing](#contributing)
- [License](#license)
- [SSH Agent Setup](#ssh-agent-setup)
- [Environment Variable Details](#environment-variable-details)
- [GitHub SSH Setup](#github-ssh-setup)

## Quick Start

1. Clone this repository
2. Copy `.devcontainer/config/.env.example` to `.devcontainer/config/.env`
3. Update the environment variables in `.env` with your settings
4. From your local machine, launch the editor with '''./launch.sh'''
5. When prompted, click "Reopen in Container"

## Setting Up a New GitHub Project

1. **Create a New Repository**

   ```bash
   # Clone this template
   git clone https://github.com/eduardoshanahan/devcontainers-git your-new-project
   cd your-new-project

   # Remove the existing git history
   rm -rf .git

   # Initialize a new git repository
   git init

   # Create a new repository on GitHub (without README, .gitignore, or license)
   # Then add your new remote
   git remote add origin git@github.com:yourusername/your-new-project.git
   ```

2. **Update Project Information**

   ```bash
   # Update the README.md with your project details
   # Update the LICENSE file if needed
   # Update any other project-specific files
   ```

3. **Configure Environment**

   ```bash
   # Copy and configure the environment file
   cp .devcontainer/config/.env.example .devcontainer/config/.env
   # Edit .env with your project-specific settings
   ```

4. **Initial Commit**

   ```bash
   # Add all files
   git add .

   # Create initial commit
   git commit -m "Initial commit: Project setup with devcontainer template"

   # Push to GitHub
   git push -u origin main
   ```

5. **Verify Setup**
   - Start VS Code with '''./launch.sh'''
   - Click "Reopen in Container"
   - Verify that the container builds successfully
   - Check that your Git configuration is working:

     ```bash
     git config --list
     ```

## Usage

### Requirements

1. **Docker**
   - Installed and running
   - Proper permissions to run containers
   - Sufficient system resources allocated

- **VS Code**
  - Version: 1.60.0 or higher
  - Required Extensions:
    - Remote - Containers (ms-vscode-remote.remote-containers)
    - Docker (ms-azuretools.vscode-docker)
    - GitLens (optional but recommended)

- **Git**
  - Version: 2.30.0 or higher
  - SSH key configured (recommended)

- **Operating System**
  - Linux: I use it with Ubuntu, I would expect it to work with other distributions

### Basic Usage

1. **Initial Setup**

   ```bash
   cd <repository-name>
   ./launch.sh
   ```

2. **Starting the Container**
   - Click "Reopen in Container" when prompted
   - Wait for the container to build and start

3. **Working in the Container**
   - All development tools are pre-installed
   - Git is configured with your credentials
   - SSH agent forwarding is enabled
   - Your local files are mounted in the container

4. **Customizing the Environment**
   - Edit `.devcontainer/config/.env` to change settings
   - Modify `.devcontainer/Dockerfile` to add new tools
   - Update `.devcontainer/devcontainer.json` for VS Code settings

### Advanced Usage

#### SSH Agent Forwarding

The container automatically forwards your SSH agent:

```bash
# Test SSH connection
ssh -T git@github.com
```

#### Environment Variables

Key environment variables:

- `HOST_USERNAME`: Your host machine username
- `HOST_UID`: Your host user ID
- `HOST_GID`: Your host group ID
- `CONTAINER_HOSTNAME`: Container hostname (default: dev)
- `EDITOR_CHOICE`: Preferred editor (code/cursor)
- `GIT_USER_NAME`: Git commit author name
- `GIT_USER_EMAIL`: Git commit author email

## Environment Variable Details

The development container uses environment variables for configuration. These are defined in the `.env` file in `.devcontainer/config/`, which should be created by copying `.env.example`.

### Required Variables

| Variable | Description | Format | How to Get |
|----------|-------------|--------|------------|
| HOST_USERNAME | Your system username | Letters, numbers, underscore, hyphen | `echo $USER` |
| HOST_UID | Your user ID | Positive integer | `id -u` |
| HOST_GID | Your group ID | Positive integer | `id -g` |

### Optional Variables

| Variable | Description | Default | Format |
|----------|-------------|---------|--------|
| CONTAINER_HOSTNAME | Container hostname shown in prompt | dev | Letters, numbers, hyphens |
| EDITOR_CHOICE | Preferred editor | cursor | 'code' or 'cursor' |
| GIT_USER_NAME | Git commit author name | Dev User | Letters, numbers, spaces, dots |
| GIT_USER_EMAIL | Git commit author email | <dev@example.com> | Valid email address |
| DOCKER_IMAGE_NAME | Development container image name | dev-container | Lowercase letters, numbers, symbols |
| DOCKER_IMAGE_TAG | Development container image tag | latest | Letters, numbers, symbols |

### Environment Validation

The development container includes automatic environment variable validation:

1. Copy `.env.example` to `.env` in `.devcontainer/config/` and update the values
2. The `validate-env.sh` script checks all variables during container creation
3. Required variables must be set with valid values
4. Optional variables will use defaults if not set
5. Validation errors will prevent container creation

## Development Container Setup

This project is designed to be cloned and used as a starting point for setting up a development container environment. It provides:

1. A standardized container configuration
2. Automated environment setup
3. Built-in security features
4. VS Code integration
5. Modern terminal experience with Starship
6. JSON processing tools and linters

## Customization

### Adding New Tools

To add new development tools, modify the Dockerfile:

```dockerfile
RUN apt-get update && apt-get install -y \
    your-package-name \
    another-package \
    && rm -rf /var/lib/apt/lists/*
```

### Modifying the Prompt

The prompt configuration is in `.devcontainer/scripts/bash-prompt.sh`. You can modify it to:

- Change colors
- Add/remove information
- Modify the layout

### Adding VS Code Extensions

Add extensions in the `devcontainer.json` file:

```json
"customizations": {
    "vscode": {
        "extensions": [
            "ms-azuretools.vscode-docker",
            "your.extension-id"
        ]
    }
}
```

## Project Structure

```text
.devcontainer/
├── config/                # Configuration files
│   ├── .env              # Environment variables
│   ├── .env.example      # Example environment variables
│   └── starship.toml     # Starship prompt configuration
├── scripts/              # Shell scripts
│   ├── post-create.sh    # Post-creation setup script
│   └── bash-prompt.sh    # Shell prompt configuration
└── Dockerfile            # Container definition
```

## GitHub SSH Setup

The development container is configured to use SSH for GitHub operations. This provides several benefits:

- Secure authentication using SSH keys
- No need to enter credentials repeatedly
- Better integration with the container environment

### Verifying SSH Setup

1. Check if SSH keys are loaded:

   ```bash
   ssh-add -l
   ```

2. Test GitHub SSH connection:

   ```bash
   ssh -T git@github.com
   ```

   You should see: "Hi username! You've successfully authenticated..."

3. Verify Git remote URL:

   ```bash
   git remote -v
   ```

   Should show: `git@github.com:username/repository.git`

### Switching to SSH

If your repository is using HTTPS, switch to SSH:

```bash
git remote set-url origin git@github.com:username/repository.git
```

### Troubleshooting SSH

1. **Keys Not Loading**
   - Check SSH agent: `echo $SSH_AUTH_SOCK`
   - Verify key permissions: `ls -l ~/.ssh/`
   - Restart SSH agent: `eval "$(ssh-agent -s)"`

2. **GitHub Connection Issues**
   - Verify key is added to GitHub account
   - Check SSH connection: `ssh -vT git@github.com`
   - Ensure correct remote URL format

3. **Permission Issues**
   - SSH directory: `chmod 700 ~/.ssh`
   - Private keys: `chmod 600 ~/.ssh/id_*`
   - Public keys: `chmod 644 ~/.ssh/*.pub`

## Troubleshooting

### Common Issues

1. **Container Build Failures**
   - **Symptom**: Container fails to build with permission errors
   - **Solution**: Ensure your user has proper Docker permissions

   ```bash
   sudo usermod -aG docker $USER
   # Log out and back in for changes to take effect
   ```

2. **VS Code Connection Issues**
   - **Symptom**: VS Code cannot connect to the container
   - **Solution**:

     - Check Docker is running
     - Verify VS Code Remote - Containers extension is installed
     - Try rebuilding the container

3. **Git Authentication Problems**
   - **Symptom**: Git operations fail with authentication errors
   - **Solution**:

     - Verify SSH agent forwarding is working
     - Check your Git credentials are properly configured
     - Ensure your SSH key is added to the agent

4. **Performance Issues**
   - **Symptom**: Container is slow or unresponsive
   - **Solution**:

     - Check system resources (CPU, RAM, disk space)
     - Verify Docker resource limits
     - Consider using volume mounts instead of bind mounts

### Performance Optimization

1. **Docker Resource Management**

 Update .devcontainer/devcontainer.json:

   ```json
   {
     "runArgs": [
       "--memory=4g",
       "--cpus=2",
       "--shm-size=2g"
     ]
   }
   ```

2. **Volume Optimization**
   - Use named volumes for frequently accessed data
   - Exclude unnecessary files from mounting
   - Use `.dockerignore` to reduce build context

3. **Build Optimization**
   - Layer caching
   - Multi-stage builds
   - Minimal base images

4. **VS Code Performance**
   - Disable unnecessary extensions
   - Use workspace-specific settings
   - Configure file watching limits

### Getting Help

If you encounter issues:

1. Check the [GitHub Issues](https://github.com/eduardoshanahan/devcontainers-git/issues)
2. Review the [VS Code Remote Containers documentation](https://code.visualstudio.com/docs/remote/containers)
3. Consult the [Docker documentation](https://docs.docker.com/)
4. Create a new issue with:
   - Detailed error message
   - Steps to reproduce
   - System information
   - Relevant logs

## Backup and Data Persistence

### Container Data

1. **Volume Management**
   - Use named volumes for persistent data
   - Configure volume backups
   - Implement data retention policies

2. **Backup Strategies**

   ```bash
   # Backup a named volume
   docker run --rm -v your-volume:/source -v /backup:/backup alpine tar czf /backup/backup.tar.gz -C /source .
   
   # Restore from backup
   docker run --rm -v your-volume:/target -v /backup:/backup alpine sh -c "cd /target && tar xzf /backup/backup.tar.gz"
   ```

3. **Data Recovery**
   - Regular volume backups
   - Point-in-time recovery options
   - Disaster recovery procedures

### Configuration Backup

1. **Environment Variables**
   - Keep `.env` files outside of version control. This is to not leak details if you are keeping the project in a publig Git repository. If you are not using Synology, setup some other type of backup for private details.
   - Use environment-specific configurations
   - Document all configuration changes

2. **VS Code Settings**
   - Sync settings across devices
   - Backup workspace configurations
   - Maintain extension lists

3. **Git Configuration**
   - Backup SSH keys securely
   - Document Git credentials
   - Maintain access tokens

### Best Practices

1. **Regular Backups**
   - Schedule automated backups
   - Verify backup integrity
   - Test restoration procedures

2. **Security Considerations**
   - Encrypt sensitive data
   - Use secure backup locations
   - Implement access controls

3. **Documentation**
   - Document backup procedures
   - Maintain recovery guides
   - Update procedures regularly

## Security Notes

1. **SSH Key Security**
   - Private keys should have 600 permissions
   - Public keys should have 644 permissions
   - SSH directory should have 700 permissions
   - Never share private keys
   - Use different keys for different services

2. **Environment Variables**
   - Keep sensitive data in `.env` file
   - Never commit `.env` to version control
   - Use `.env.example` for documentation

3. **Container Security**
   - Regular updates of base image
   - Minimal installed packages
   - No root access in container
   - Secure file permissions

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## SSH Agent Setup

The SSH agent is configured automatically when you start the container:

1. **Automatic Configuration**
   - SSH agent starts automatically in new shell sessions
   - SSH keys are mounted from the host system
   - Keys are added to the agent automatically
   - Agent persists between terminal sessions

2. **Verification**

   ```bash
   # Check if SSH agent is running
   echo $SSH_AUTH_SOCK

   # List loaded keys
   ssh-add -l

   # Test GitHub connection
   ssh -T git@github.com
   ```

3. **Security Features**
   - Keys are mounted read-only from host
   - Strict permission enforcement (600 for keys, 700 for .ssh directory)
   - Keys are never stored in the container
   - Agent environment is persisted securely

### Manual SSH Setup (if needed)

1. **Start SSH Agent**

   ```bash
   eval "$(ssh-agent -s)"
   ```

2. **Add Keys**

   ```bash
   ssh-add ~/.ssh/your-key
   ```

3. **Verify Setup**

   ```bash
   ssh-add -l
   ssh -T git@github.com
   ```
