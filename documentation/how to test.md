# How to test

There are no automated tests in this repo. Use the checks below to verify the
environment before opening the devcontainer.

## Validate environment variables

```sh
./scripts/validate-env.sh [editor|devcontainer|claude]
```

## Verify SSH agent and Git config (inside the container)

```sh
./.devcontainer/scripts/verify-git-ssh.sh
```

## Quick smoke checks

- Confirm your editor opens with `./editor-launch.sh`.
- Reopen in container and confirm `git status` works in `$WORKSPACE_FOLDER`.
