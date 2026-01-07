#!/bin/sh
set -eu

required_vars='
PROJECT_NAME|Project name|^[a-z0-9][a-z0-9-]*$
HOST_USERNAME|System username|^[a-z_][a-z0-9_-]*$
HOST_UID|User ID|^[0-9]+$
HOST_GID|Group ID|^[0-9]+$
LOCALE|Locale|^[A-Za-z]{2}_[A-Za-z]{2}\.UTF-8$
CONTAINER_HOSTNAME|Container hostname|^[a-zA-Z][a-zA-Z0-9-]*$
CONTAINER_MEMORY|Container memory limit|^[0-9]+[gGmM]$
CONTAINER_CPUS|Container CPU limit|^[0-9]+(\.[0-9]+)?$
CONTAINER_SHM_SIZE|Container shared memory size|^[0-9]+[gGmM]$
GIT_USER_NAME|Git author name|^[a-zA-Z0-9 ._-]+$
GIT_USER_EMAIL|Git author email|^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$
EDITOR_CHOICE|Editor selection|^(code|cursor|antigravity)$
DOCKER_IMAGE_NAME|Docker image name|^[a-z0-9][a-z0-9._-]+$
DOCKER_IMAGE_TAG|Docker image tag|^[a-zA-Z0-9][a-zA-Z0-9._-]+$
'

optional_vars='
GIT_REMOTE_URL||^(https://|git@).+
'

validate_var() {
    var_name="$1"
    var_value="$2"
    pattern="$3"
    description="$4"

    if ! printf '%s\n' "$var_value" | grep -Eq "$pattern"; then
        echo "Error: $var_name is invalid"
        echo "Description: $description"
        echo "Pattern: $pattern"
        echo "Current value: $var_value"
        return 1
    fi
    return 0
}

errors=0
echo "Validating required variables..."
while IFS='|' read -r var description pattern; do
    [ -z "$var" ] && continue
    eval "value=\${$var:-}"
    if [ -z "$value" ]; then
        echo "Error: Required variable $var is not set"
        echo "Description: $description"
        errors=$((errors + 1))
    else
        validate_var "$var" "$value" "$pattern" "$description" || errors=$((errors + 1))
    fi
done <<EOF
$required_vars
EOF

printf '\nValidating SSH agent forwarding...\n'
if [ -z "${SSH_AUTH_SOCK:-}" ]; then
    echo "Error: SSH_AUTH_SOCK is not set. Start an SSH agent before running launch.sh."
    errors=$((errors + 1))
elif [ ! -S "${SSH_AUTH_SOCK}" ]; then
    echo "Error: SSH_AUTH_SOCK is set but is not a valid socket: ${SSH_AUTH_SOCK}"
    errors=$((errors + 1))
fi

printf '\nValidating optional variables...\n'
while IFS='|' read -r var default pattern; do
    [ -z "$var" ] && continue
    eval "value=\${$var:-$default}"
    if [ -n "$value" ]; then
        validate_var "$var" "$value" "$pattern" "Default: $default" || errors=$((errors + 1))
    fi
done <<EOF
$optional_vars
EOF

if [ "$errors" -gt 0 ]; then
    printf '\nFound %s error(s). Please fix them and try again.\n' "$errors"
    exit 1
else
    printf '\nAll environment variables are valid!\n'
fi
