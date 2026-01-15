# How to use this project

## Overview

This repository is a devcontainer template. It expects a project-specific `.env`
at the repo root and uses it as the source of truth.

## Quick start

1. Copy `.env.example` to `.env`.
2. Update `.env` with your host user, UID/GID, locale, Git identity, and editor choice.
3. Run `./editor-launch.sh`.
4. In your editor, choose "Reopen in Container".

## Launchers

- `./editor-launch.sh` opens VS Code, Cursor, or Antigravity after validating `.env`.
- `./devcontainer-launch.sh` opens a shell in the devcontainer using the CLI.
- `./claude-launch.sh` opens Claude Code in the devcontainer (if installed).
- `./workspace.sh` opens a tmux workspace on the host (optional).

## SSH agent forwarding

The devcontainer bind-mounts `SSH_AUTH_SOCK`, so the host must have a running
SSH agent before the container starts.

## Common scripts

- Validate config: `./scripts/validate-env.sh [editor|devcontainer|claude]`
- Clean old devcontainer images: `./scripts/clean-devcontainer-images.sh`

## Project-specific workflow

### Git synchronization

Use `./scripts/sync-git.sh` when you need a safe pull or push while another
file syncer is active. Configure remotes in `.env` using `GIT_SYNC_REMOTES`,
`GIT_SYNC_PUSH_REMOTES`, and optional `GIT_REMOTE_URL_<REMOTE>` entries.
