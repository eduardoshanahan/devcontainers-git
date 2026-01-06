# How to use this project

This repository is a devcontainer template. It expects a project-specific
`.env` at the repo root and uses it as the source of truth.

## Quick Start

1. Copy `.env.example` to `.env`.
2. Update `.env` with your host user, UID/GID, Git identity, and editor choice.
3. Run `./editor-launch.sh`.
4. In your editor, choose "Reopen in Container".

## Launch options

- `./editor-launch.sh` opens VS Code, Cursor, or Antigravity after validating `.env`.
- `./devcontainer-launch.sh` opens a shell in the devcontainer using the CLI.
- `./claude-launch.sh` opens Claude Code in the devcontainer (if installed).

## SSH agent forwarding

The devcontainer bind-mounts `SSH_AUTH_SOCK`, so the host must have a running
SSH agent before the container starts.

## Git synchronization

Use `./scripts/sync-git.sh` when you need a safe pull or push while another
file syncer is active. Configure remotes in `.env` using `GIT_SYNC_REMOTES`,
`GIT_SYNC_PUSH_REMOTES`, and optional `GIT_REMOTE_URL_<REMOTE>` entries.
