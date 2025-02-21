#!/bin/bash

# Set strict bash options
set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print error messages
error() {
    echo -e "${RED}ERROR: $1${NC}" >&2
}

# Function to print success messages
success() {
    echo -e "${GREEN}$1${NC}"
}

# Function to print info messages
info() {
    echo -e "${YELLOW}$1${NC}"
}

# Function to check if a variable is set
check_var() {
    local var_name="$1"
    local var_value="$2"
    if [ -z "$var_value" ]; then
        error "$var_name is not set in .devcontainer/.env"
        return 1
    fi
    info "$var_name: $var_value"
}

# Check if .env file exists
if [ ! -f .devcontainer/.env ]; then
    error ".devcontainer/.env file not found!"
    error "Please create it with the following variables:"
    echo "HOST_USERNAME=your_username"
    echo "HOST_UID=your_uid"
    echo "HOST_GID=your_gid"
    echo "GIT_USER_NAME=\"Your Name\""
    echo "GIT_USER_EMAIL=your.email@example.com"
    exit 1
fi

# Load environment variables from .devcontainer/.env
info "Loading environment variables..."
set -a
source .devcontainer/.env
set +a

# Verify required variables
required_vars=(
    "HOST_USERNAME"
    "HOST_UID"
    "HOST_GID"
    "GIT_USER_NAME"
    "GIT_USER_EMAIL"
)

# Check all required variables
for var in "${required_vars[@]}"; do
    check_var "$var" "${!var:-}" || exit 1
done

# Check if cursor is installed
if ! command -v cursor &>/dev/null; then
    error "Cursor is not installed!"
    error "Please install Cursor from https://cursor.sh"
    exit 1
fi

# Launch Cursor
info "Launching Cursor..."
cursor . --no-sandbox

success "Cursor launched successfully!"
