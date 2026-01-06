#!/bin/sh
# Shared env loader: load project-root .env (authoritative) then fill missing from .devcontainer/config/.env
# Usage:
#   # from inside container: . /workspace/.devcontainer/scripts/env-loader.sh && load_project_env /workspace [debug]
#   # from host script: . "$PROJECT_DIR/.devcontainer/scripts/env-loader.sh" && load_project_env "$PROJECT_DIR" [debug]
#
# Debug mode:
#   - Set ENV_LOADER_DEBUG=1 (exported) or pass second param as 1 to load_project_env to print loaded vars.

load_project_env() {
    workspace_dir="${1:-/workspace}"
    debug="${2:-${ENV_LOADER_DEBUG:-0}}"
    project_env="$workspace_dir/.env"
    dev_env="$workspace_dir/.devcontainer/config/.env"
    loaded_keys=""

    add_loaded_key() {
        key="$1"
        case " $loaded_keys " in
            *" $key "*) return ;;
        esac
        loaded_keys="${loaded_keys} ${key}"
    }

    # Load project root .env first (authoritative); preserve quoting
    if [ -f "$project_env" ]; then
        set -a
        # shellcheck disable=SC1090
        . "$project_env"
        set +a
        while IFS= read -r line || [ -n "$line" ]; do
            trimmed=$(printf '%s' "$line" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
            [ -z "$trimmed" ] && continue
            case "$trimmed" in \#*) continue ;; esac
            key=${trimmed%%=*}
            key=$(printf '%s' "$key" | xargs)
            [ -n "$key" ] && add_loaded_key "$key"
        done < "$project_env"
    fi

    # Fill missing variables from devcontainer config without overwriting existing ones
    if [ -f "$dev_env" ]; then
        while IFS= read -r line || [ -n "$line" ]; do
            trimmed=$(printf '%s' "$line" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
            [ -z "$trimmed" ] && continue
            case "$trimmed" in \#*) continue ;; esac
            key=${trimmed%%=*}
            key=$(printf '%s' "$key" | xargs)
            if [ -n "$key" ]; then
                eval "existing_value=\${$key:-}"
                if [ -z "$existing_value" ]; then
                    # Preserve quoting in value
                    eval "export $trimmed"
                    add_loaded_key "$key"
                fi
            fi
        done < "$dev_env"
    fi

    if [ "$debug" = "1" ] || [ "$debug" = "true" ]; then
        echo "env-loader: debug enabled -- listing variables set by load_project_env (workspace: $workspace_dir)"
        for key in $loaded_keys; do
            eval "value=\${$key:-}"
            printf '%s=%s\n' "$key" "$value"
        done
    fi
}
