#!/bin/bash

# Load environment variables via shared loader (project root .env is authoritative)
if [ -f "/workspace/.devcontainer/scripts/env-loader.sh" ]; then
    # shellcheck disable=SC1090
    source "/workspace/.devcontainer/scripts/env-loader.sh"
    load_project_env "/workspace"
elif [ -f "$HOME/.devcontainer/scripts/env-loader.sh" ]; then
    # shellcheck disable=SC1090
    source "$HOME/.devcontainer/scripts/env-loader.sh"
    load_project_env "/workspace"
else
    echo "Warning: env-loader.sh not found; skipping environment load"
fi

# Configure Git if variables are set
if [ -n "$GIT_USER_NAME" ] && [ -n "$GIT_USER_EMAIL" ]; then
    REPO_DIR="/workspace"
    if [ -d "$REPO_DIR/.git" ]; then
        echo "Configuring repo-local Git identity:"
        echo "  Name:  $GIT_USER_NAME"
        echo "  Email: $GIT_USER_EMAIL"
        git -C "$REPO_DIR" config user.name "$GIT_USER_NAME"
        git -C "$REPO_DIR" config user.email "$GIT_USER_EMAIL"
    else
        echo "Warning: No git repository found in $REPO_DIR. Skipping git identity setup."
    fi
else
    echo "Warning: GIT_USER_NAME or GIT_USER_EMAIL not set. Git identity not configured."
fi

# Add workspace to Git safe directories
echo "Configuring Git safe directories..."
git config --global --add safe.directory /workspace
git config --global --add safe.directory /home/${USERNAME}/.devcontainer

# Make scripts executable
chmod +x /workspace/.devcontainer/scripts/bash-prompt.sh
chmod +x /workspace/.devcontainer/scripts/ssh-agent-setup.sh

# Ensure helper fixer is executable and run it to set permissions for helper scripts
if [ -f "/workspace/.devcontainer/scripts/fix-permissions.sh" ]; then
    chmod +x "/workspace/.devcontainer/scripts/fix-permissions.sh" 2>/dev/null || true
    # Run fixer (non-fatal)
    "/workspace/.devcontainer/scripts/fix-permissions.sh" "/workspace/.devcontainer/scripts" || true
fi

# Source scripts in bashrc if not already present
if ! grep -q "source.*bash-prompt.sh" ~/.bashrc; then
    echo 'source /workspace/.devcontainer/scripts/bash-prompt.sh' >> ~/.bashrc
fi

if ! grep -q "source.*ssh-agent-setup.sh" ~/.bashrc; then
    echo 'source /workspace/.devcontainer/scripts/ssh-agent-setup.sh' >> ~/.bashrc
fi

# Ensure login shells also inherit the alias setup by sourcing .bashrc
ensure_profile_sources_bashrc() {
    local profile_file="$1"
    [ -f "$profile_file" ] || touch "$profile_file"
    if ! grep -q "source ~/.bashrc" "$profile_file"; then
        cat <<'EOF' >> "$profile_file"
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi
EOF
    fi
}

ensure_profile_sources_bashrc ~/.bash_profile
ensure_profile_sources_bashrc ~/.profile
