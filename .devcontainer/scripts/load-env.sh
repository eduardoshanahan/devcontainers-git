#!/bin/sh
set -eu

# Determine project directory (defaults to current working directory)
PROJECT_DIR="${PROJECT_DIR:-$(pwd)}"
ENV_LOADER="$PROJECT_DIR/.devcontainer/scripts/env-loader.sh"

if [ ! -f "$ENV_LOADER" ]; then
    echo "Error: env-loader.sh not found at $ENV_LOADER"
    exit 1
fi

# Load variables: project root .env is authoritative
# shellcheck disable=SC1090
. "$ENV_LOADER"
load_project_env "$PROJECT_DIR"

# No implicit defaults; required variables must be defined in .env
required_vars="CONTAINER_MEMORY CONTAINER_CPUS CONTAINER_SHM_SIZE CONTAINER_HOSTNAME"

missing=0
for var in $required_vars; do
  eval "value=\${$var:-}"
  if [ -z "$value" ]; then
    echo "Error: Required variable $var is not set"
    missing=1
  fi
done

if [ "$missing" -ne 0 ]; then
  exit 1
fi

echo "Container configuration:"
echo "  Memory: $CONTAINER_MEMORY"
echo "  CPUs: $CONTAINER_CPUS"
echo "  Shared Memory: $CONTAINER_SHM_SIZE"
echo "  Hostname: $CONTAINER_HOSTNAME"
