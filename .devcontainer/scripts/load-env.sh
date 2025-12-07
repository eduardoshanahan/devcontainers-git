#!/bin/bash

# Load environment variables from project root .env if present (authoritative)
if [ -f .env ]; then
    echo "Loading environment variables from .env file..."
    set -a
    # shellcheck disable=SC1090
    source .env
    set +a
elif [ -f .devcontainer/config/.env ]; then
    echo "Loading environment variables from .devcontainer/config/.env file..."
    set -a
    # shellcheck disable=SC1090
    source .devcontainer/config/.env
    set +a
fi

# Additionally, fill missing vars from .devcontainer/config/.env without overwriting root .env
if [ -f .devcontainer/config/.env ]; then
    while IFS= read -r line || [ -n "$line" ]; do
        trimmed="$(echo "$line" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
        [ -z "$trimmed" ] && continue
        case "$trimmed" in \#*) continue ;; esac
        key="${trimmed%%=*}"
        key="$(echo "$key" | xargs)"
        if [ -z "${!key:-}" ]; then
            eval "export $trimmed"
        fi
    done < .devcontainer/config/.env
fi

# Use shared loader if available, otherwise fallback to existing behavior
if [ -f ".devcontainer/scripts/env-loader.sh" ]; then
    # shellcheck disable=SC1090
    source ".devcontainer/scripts/env-loader.sh"
    load_project_env "$(pwd)"
elif [ -f .env ]; then
    set -a
    # shellcheck disable=SC1090
    source .env
    set +a
elif [ -f .devcontainer/config/.env ]; then
    set -a
    # shellcheck disable=SC1090
    source .devcontainer/config/.env
    set +a
fi

# Set defaults for container resource limits if not defined
export CONTAINER_MEMORY=${CONTAINER_MEMORY:-4g}
export CONTAINER_CPUS=${CONTAINER_CPUS:-2}
export CONTAINER_SHM_SIZE=${CONTAINER_SHM_SIZE:-2g}

# Set defaults for other variables if not defined
export CONTAINER_HOSTNAME=${CONTAINER_HOSTNAME:-devcontainers-git}
export PYTHON_VERSION=${PYTHON_VERSION:-3.11}
export ANSIBLE_VERSION=${ANSIBLE_VERSION:-9.2.0}
export ANSIBLE_LINT_VERSION=${ANSIBLE_LINT_VERSION:-25.1.3}

echo "Container configuration:"
echo "  Memory: $CONTAINER_MEMORY"
echo "  CPUs: $CONTAINER_CPUS"
echo "  Shared Memory: $CONTAINER_SHM_SIZE"
echo "  Hostname: $CONTAINER_HOSTNAME"
echo "  Python: $PYTHON_VERSION"
echo "  Ansible: $ANSIBLE_VERSION"
echo "  Ansible Lint: $ANSIBLE_LINT_VERSION"