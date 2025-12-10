#!/bin/bash
set -euo pipefail

# Prefer workspace colors, then HOME; fallback to minimal colors
if [ -f "/workspace/.devcontainer/scripts/colors.sh" ]; then
    source "/workspace/.devcontainer/scripts/colors.sh"
elif [ -f "$HOME/.devcontainer/scripts/colors.sh" ]; then
    source "$HOME/.devcontainer/scripts/colors.sh"
else
    COLOR_RESET='\033[0m'
    COLOR_BOLD='\033[1m'
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[0;33m'
fi

# Load environment variables via shared loader (project root .env is authoritative)
loader_found=false
for loader in "/workspace/.devcontainer/scripts/env-loader.sh" "$HOME/.devcontainer/scripts/env-loader.sh"; do
    if [ -f "$loader" ]; then
        # shellcheck disable=SC1090
        source "$loader"
        load_project_env "/workspace"
        loader_found=true
        break
    fi
done

if [ "$loader_found" = false ]; then
    echo -e "${YELLOW}Warning: env-loader.sh not found; environment variables may be missing${COLOR_RESET}"
fi

# Validate environment variables (run as separate process)
if [ -f "/workspace/.devcontainer/scripts/validate-env.sh" ]; then
    if ! bash "/workspace/.devcontainer/scripts/validate-env.sh"; then
        echo -e "${RED}Environment validation failed. Please check your .env file${COLOR_RESET}"
        exit 1
    fi
else
    echo -e "${YELLOW}Warning: validate-env.sh not found, skipping environment validation${COLOR_RESET}"
fi

# Configure Git if variables are set
if [ -n "${GIT_USER_NAME:-}" ] && [ -n "${GIT_USER_EMAIL:-}" ]; then
    echo -e "${GREEN}Configuring Git with:${COLOR_RESET}"
    echo -e "  ${COLOR_BOLD}Name:${COLOR_RESET}  $GIT_USER_NAME"
    echo -e "  ${COLOR_BOLD}Email:${COLOR_RESET} $GIT_USER_EMAIL"
    git config --global user.name "$GIT_USER_NAME"
    git config --global user.email "$GIT_USER_EMAIL"
fi

# Make scripts executable (existing entries)
chmod +x /workspace/.devcontainer/scripts/bash-prompt.sh 2>/dev/null || true
chmod +x /workspace/.devcontainer/scripts/ssh-agent-setup.sh 2>/dev/null || true

# Ensure helper scripts are executable
chmod +x /workspace/.devcontainer/scripts/verify-git-ssh.sh 2>/dev/null || true
chmod +x /workspace/.devcontainer/scripts/env-loader.sh 2>/dev/null || true
chmod +x /workspace/.devcontainer/scripts/fix-permissions.sh 2>/dev/null || true

# Ensure bashrc sources helper scripts (avoid duplicates)
if ! grep -qF "source /workspace/.devcontainer/scripts/bash-prompt.sh" ~/.bashrc 2>/dev/null; then
    echo 'source /workspace/.devcontainer/scripts/bash-prompt.sh' >> ~/.bashrc
fi

if ! grep -qF "source /workspace/.devcontainer/scripts/ssh-agent-setup.sh" ~/.bashrc 2>/dev/null; then
    echo 'source /workspace/.devcontainer/scripts/ssh-agent-setup.sh' >> ~/.bashrc
fi

echo -e "${GREEN}Initialization complete.${COLOR_RESET}"
