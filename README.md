# Git Development Environment in Devcontainers

This repository provides a ready-to-use development environment using devcontainers, supporting both Visual Studio Code and Cursor editors. It ensures consistent Git configuration and proper file permissions whether you're working inside the container or on the host machine.

## Features

- Secure user permissions matching host system
- Consistent Git configuration across environments
- Pre-configured development tools and utilities
- Support for both VS Code and Cursor editors
- Customized shell with useful aliases and tools
- GitHub CLI integration
- Enhanced code search and navigation

## Prerequisites

- Ubuntu (tested on Ubuntu 24.10)
- Docker installed and running
- One of the following editors:
  - Visual Studio Code with Remote - Containers extension
  - Cursor Editor

## Quick Start

### 1. Clone and Initialize

```bash
# Clone the repository
git clone --depth 1 https://github.com/eduardoshanahan/devcontainers-git new-project-name
cd new-project-name

# Remove Git history to start fresh
rm -rf .git/
git init
```

### 2. Configure Environment

```bash
# Copy environment template
cp .devcontainer/.env.example .devcontainer/.env

# Get your user details (note these values)
echo "Your username: $(whoami)"
echo "Your UID: $(id -u)"
echo "Your GID: $(id -g)"

# Edit the environment file
code .devcontainer/.env  # or cursor .devcontainer/.env
```

Required environment variables:

```dotenv
# User configuration
HOST_USERNAME="your_username"     # Output of whoami
HOST_UID=1000                     # Output of id -u
HOST_GID=1000                     # Output of id -g

# Git configuration
GIT_USER_NAME="Your Name"         # Your Git username
GIT_USER_EMAIL="your@email.com"   # Your Git email

# Editor configuration
EDITOR_CHOICE=code               # Use 'code' for VS Code or 'cursor' for Cursor

# Docker configuration
DOCKER_IMAGE_NAME="your-image"    # Name for the Docker image
DOCKER_IMAGE_TAG="1.0.0"         # Tag for the Docker image
```

### Docker Image Management

By default, VS Code creates Docker images with auto-generated names. To use custom names:

1. Set these variables in `.devcontainer/.env`:

```bash
DOCKER_IMAGE_NAME="your-image-name"
DOCKER_IMAGE_TAG="your-tag"
```

1. To clean up old images and rebuild with new names:

```bash
# Stop containers using old images
docker stop $(docker ps -q --filter ancestor=<old-image-name>)

# Remove old images
docker image rm <old-image-name>:latest
docker image rm <old-image-name-uid>:latest

# Rebuild with new name
./launch.sh
```

The container will be rebuilt with your specified image name and tag.

### 3. Launch the Environment

```bash
# Launch your chosen editor (VS Code or Cursor)
./launch.sh
```

The script will:

- Validate your environment configuration
- Check if your chosen editor is installed
- Clean up any existing containers
- Launch the appropriate editor

If there are any issues, the script will provide helpful error messages and instructions.

## Included Tools and Features

### Development Tools

- Git with enhanced configuration
- GitHub CLI
- Build essentials
- curl, wget, jq
- zip/unzip utilities
- tree, htop
- bash-completion

### Git Aliases

| Alias | Command                   | Description                      |
| ----- | ------------------------- | -------------------------------- |
| gs    | git status                | Show working tree status         |
| gp    | git pull                  | Pull changes from remote         |
| gd    | git diff                  | Show file differences            |
| gc    | git commit                | Create a commit                  |
| gb    | git branch                | List or manage branches          |
| gl    | git log --oneline --graph | Show commit history graph        |
| gco   | git checkout              | Switch branches or restore files |
| gf    | git fetch --all --prune   | Update remote references         |
| gst   | git stash                 | Stash changes                    |
| gstp  | git stash pop             | Apply stashed changes            |

## VS Code Extensions

The environment comes with pre-configured extensions for:

- Docker and container management
- Git integration and visualization
- Code intelligence and completion
- Markdown support
- Code formatting and linting
- Spell checking
- File icons and themes

## Troubleshooting

### Permission Issues

```bash
# Verify your host machine IDs match .env
id -u  # Should match HOST_UID
id -g  # Should match HOST_GID

# Check container user
docker exec <container-name> id
```

### Editor Launch Issues

```bash
# Check if editor is installed
command -v code    # For VS Code
command -v cursor  # For Cursor

# Verify environment variables
cat .devcontainer/.env
```

### Git Configuration

```bash
# Verify Git configuration
git config --global --list

# Reset Git configuration if needed
git config --global --unset-all user.name
git config --global --unset-all user.email
```

## Testing Git Setup

To verify that Git is working correctly in your container, follow these steps:

### 1. Check Git Installation and Configuration

```bash
# Verify Git version and configuration
git --version
git config --global --list
```

Expected output should show:

- Git version installed
- Your configured username and email
- Core settings like editor, file mode, etc.

### 2. Test Basic Git Operations

```bash
# Create and stage a test file
echo "test content" > test.txt
git add test.txt
git status  # Should show test.txt as staged

# Create a test commit
git commit -m "test commit" test.txt
git log -1  # Should show your commit

# Test file modifications
rm test.txt
git status  # Should show test.txt as deleted
```

### 3. Verify Git Aliases

```bash
# Test common aliases
gs   # git status
gl   # git log with graph
gd   # git diff
```

### 4. What to Check

✓ Git installation:

- Git command works
- Correct version is installed
- Configuration is properly set

✓ Basic operations:

- File staging works
- Commits are created correctly
- Status shows changes accurately
- Log shows commit history

✓ Permissions:

- Files can be created/deleted
- Git can track changes
- No permission errors in operations

If any of these tests fail, check:

1. Your container user permissions
2. Git global configuration
3. Environment variables in `.devcontainer/.env`

## Project Structure

```text
.
├── .devcontainer/
│   ├── Dockerfile          # Container definition
│   ├── devcontainer.json   # Dev container configuration
│   ├── .env.example        # Environment template
│   └── .env               # Your environment variables
├── .vscode/
│   └── settings.json      # Editor settings
├── launch.sh              # Unified launcher
└── README.md             # This file
```

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- [Visual Studio Code Dev Containers](https://code.visualstudio.com/docs/remote/containers)
- [Cursor Editor](https://cursor.sh/)
- [GitHub CLI](https://cli.github.com/)
