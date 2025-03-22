# Development Container Template

## Table of Contents

- [Project Aim](#project-aim)
- [Quick Start](#quick-start)
- [Setting Up a New GitHub Project](#setting-up-a-new-github-project)
- [Usage](#usage)
  - [Prerequisites](#prerequisites)
  - [Basic Usage](#basic-usage)
  - [Advanced Usage](#advanced-usage)
- [Development Container Setup](#development-container-setup)
- [Customization](#customization)
- [Project Structure](#project-structure)
- [Troubleshooting](#troubleshooting)
- [Security Notes](#security-notes)
- [Contributing](#contributing)
- [License](#license)
- [SSH Agent Setup](#ssh-agent-setup)
- [Environment Variable Details](#environment-variable-details)

## Project Aim

This project provides a standardized development container setup that enables consistent development environments across different machines and operating systems. It's designed to:

- Eliminate "it works on my machine" problems by providing a consistent development environment
- Speed up project onboarding by automating environment setup
- Support VS Code while maintaining consistent tooling
- Provide a secure and isolated development environment
- Enable easy customization through environment variables
- Support both local and remote development scenarios
- Maintain consistent user permissions across different machines and file synchronization services

The container ensures consistent user permissions and Git configurations by matching the host user's UID/GID and Git credentials inside the container, making it ideal for developers working across multiple machines or using file synchronization services.

## Quick Start

1. Clone this repository
2. Copy `.devcontainer/config/.env.example` to `.devcontainer/config/.env`
3. Update the environment variables in `.env` with your settings
4. Open the project in VS Code
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
   git remote add origin https://github.com/yourusername/your-new-project.git
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
   - Open the project in VS Code
   - Click "Reopen in Container"
   - Verify that the container builds successfully
   - Check that your Git configuration is working:

     ```bash
     git config --list
     ```

## Usage

### Prerequisites

- Docker Desktop installed and running
- VS Code with Remote - Containers extension
- Git

### Basic Usage

1. **Initial Setup**

   ```bash
   # Clone the repository
   git clone <repository-url>
   cd <repository-name>

   # Copy the example environment file
   cp .devcontainer/config/.env.example .devcontainer/config/.env

   # Edit the environment file with your settings
   nano .devcontainer/config/.env
   ```

2. **Starting the Container**
   - Open the project in VS Code
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

## Features

### Development Tools

The development container comes with several pre-installed tools and features:

1. **Docker Integration**
   - Microsoft Docker extension (`ms-azuretools.vscode-docker`)
   - Full Docker CLI support
   - Container management and debugging capabilities
   - Integrated Docker Desktop support

2. **Modern Shell Experience**
   - Starship prompt for beautiful and informative terminal
   - Custom-configured prompt with Git status, Python env, Node.js version
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

### Customizing the Environment

#### Shell Prompt Customization

The container uses Starship for the shell prompt. To customize it:

1. Edit `.devcontainer/config/starship.toml`
2. Refer to [Starship documentation](https://starship.rs/config/) for options
3. Changes take effect immediately in new terminal sessions

Example starship.toml configuration:
```toml
# Custom prompt format
format = """
$username\
$hostname\
$directory\
$git_branch\
$git_status\
$nodejs\
$python\
$docker_context\
$line_break\
$character"""

[character]
success_symbol = "[➜](bold green) "
error_symbol = "[✗](bold red) "
```

#### JSON Tools Usage

The container includes several JSON-related tools:

1. Command-line tools:
   ```bash
   # Format JSON file
   cat file.json | jsonformat > formatted.json

   # Validate JSON syntax
   jsonvalidate < file.json

   # Pretty print JSON
   echo '{"key": "value"}' | jsonpretty
   ```

2. VS Code Integration:
   - Format on save with Prettier
   - Real-time JSON validation with ESLint
   - Syntax highlighting and error detection

## Troubleshooting

1. **Wrong User ID/Group ID**
   - Check your host system IDs with `id -u` and `id -g`
   - Update the `.env` file in `.devcontainer/config/` with correct values
   - Rebuild the container

2. **SSH Keys Not Working**
   - Check key permissions on host (600 for private, 644 for public)
   - Verify SSH directory permissions (700)
   - Check if keys are loaded with `ssh-add -l`
   - Look for SSH agent messages in terminal startup

3. **Git SSH Operations Failing**
   - Ensure SSH agent is running: `echo $SSH_AUTH_SOCK`
   - Verify keys are added: `ssh-add -l`
   - Check key permissions
   - Try `ssh -T git@github.com` to test connection

4. **File Permission Issues**
   - Verify HOST_UID and HOST_GID match your system
   - Check the ownership of mounted volumes
   - Rebuild the container if needed

## Security Notes

1. **SSH Configuration**
   - SSH keys are mounted read-only from host
   - Permissions are strictly enforced
   - Agent environment is persisted securely
   - Keys are never stored in container image

2. **Container Security**
   - User runs with same UID/GID as host
   - Sudo access is controlled
   - Sensitive files have restricted permissions

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a new Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

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

If you need to manually manage SSH keys:

1. **Start SSH Agent**

   ```bash
   # Start the agent manually
   eval "$(ssh-agent -s)"
   ```

2. **Add Keys Manually**

   ```bash
   # Add a specific key
   ssh-add ~/.ssh/id_rsa  # or id_ed25519, etc.

   # Add all keys
   ssh-add
   ```

3. **Fix Permissions**

   ```bash
   # Set correct permissions on SSH directory
   chmod 700 ~/.ssh

   # Set correct permissions on keys
   chmod 600 ~/.ssh/id_rsa
   chmod 644 ~/.ssh/id_rsa.pub
   ```

4. **Reset SSH Agent**

   ```bash
   # Kill existing agent
   ssh-agent -k

   # Start new agent
   eval "$(ssh-agent -s)"
   ```
