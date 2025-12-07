#!/bin/bash

# Load environment variables: prefer workspace root .env then fill missing from .devcontainer/config/.env
if [ -f "/workspace/.env" ]; then
    # shellcheck disable=SC1090
    source "/workspace/.env"
fi

if [ -f "/workspace/.devcontainer/config/.env" ]; then
    while IFS= read -r line || [ -n "$line" ]; do
        trimmed="$(echo "$line" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
        [ -z "$trimmed" ] && continue
        case "$trimmed" in \#*) continue ;; esac
        key="${trimmed%%=*}"
        key="$(echo "$key" | xargs)"
        if [ -z "${!key:-}" ]; then
            eval "export $trimmed"
        fi
    done < "/workspace/.devcontainer/config/.env"
fi

# Try to source shared env loader and apply project envs
if [ -f "/workspace/.devcontainer/scripts/env-loader.sh" ]; then
    # shellcheck disable=SC1090
    source "/workspace/.devcontainer/scripts/env-loader.sh"
    load_project_env "/workspace"
elif [ -f "/workspace/.env" ]; then
    # fallback: just source root .env
    # shellcheck disable=SC1090
    source "/workspace/.env"
else
    echo "Warning: env-loader.sh and /workspace/.env not found; skipping env load"
fi

# Validate environment variables
if [ -f "/workspace/.devcontainer/scripts/validate-env.sh" ]; then
    source "/workspace/.devcontainer/scripts/validate-env.sh"
    if [ $? -ne 0 ]; then
        echo "Environment validation failed. Please check your .env file"
        exit 1
    fi
else
    echo "Warning: validate-env.sh not found, skipping environment validation"
fi

# Configure Git if variables are set
# Configure Git if variables are set
if [ -n "$GIT_USER_NAME" ] && [ -n "$GIT_USER_EMAIL" ]; then
    echo "Configuring Git with:"
    echo "  Name:  $GIT_USER_NAME"
    echo "  Email: $GIT_USER_EMAIL"
    # Ensure .gitconfig exists
    touch ~/.gitconfig
    git config --global user.name "$GIT_USER_NAME"
    git config --global user.email "$GIT_USER_EMAIL"
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
