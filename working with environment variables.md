# Working with environment variables (TL;DR)

1. **Copy the template:** `cp .env.example .env` (only needs to happen once per project).
2. **Fill in the values:** edit `.env` so that `HOST_USERNAME`, `HOST_UID`, `HOST_GID`, Git info, editor choice, etc. match your machine. This file is the single source of truth; `.devcontainer/config/.env` only provides defaults.
3. **Optionally reuse defaults:** if a variable is missing from `.env`, the loader fills it from `.devcontainer/config/.env`, so you can leave optional values blank.
4. **Validate & launch:** run `./launch.sh` (or open the folder in your editor). The script loads `.env`, runs the validator, and then opens VS Code/Cursor/Antigravity so you can use “Reopen in Container”. If something is wrong, the validator prints what to fix before the editor starts.
5. **Inside the container:** every helper script sources `.devcontainer/scripts/env-loader.sh`, so anything defined in `.env` automatically shows up in init/post-create hooks and in your shell.
6. **Adding new variables:** document them in `.env.example`, consume them via `env-loader.sh`, and (if they’re required) add a rule to `.devcontainer/scripts/validate-env.sh`. No other script needs to change.

Keep `.env` out of version control (already covered by `.gitignore`) so each machine can store its own user-specific values without conflicts.
