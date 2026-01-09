# Development Container Template - Just Git

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Docker](https://img.shields.io/badge/Docker-Required-blue)](https://www.docker.com/)
[![VS Code](https://img.shields.io/badge/VS%20Code-Required-blue)](https://code.visualstudio.com/)

This repository is a devcontainer template for Git-focused work with strict
UID/GID matching, SSH agent forwarding, and optional sync helpers.

## Quick Start

1. Copy `.env.example` to `.env`.
2. Fill in `.env` with your host user, UID/GID, locale, Git identity, editor choice,
   container resource limits, and image naming values.
3. Run `./editor-launch.sh`.
4. In your editor, choose "Reopen in Container".
5. Ensure `SSH_AUTH_SOCK` is available on the host before reopening.
6. Use `./scripts/sync-git.sh` when you need a safe pull or push.

## Key Docs

- Documentation index: [documentation/README.md](documentation/README.md)
- Environment variables: [working with environment variables](documentation/working%20with%20environment%20variables.md)
- Usage: [how to use this project.md](documentation/how%20to%20use%20this%20project.md)
- Testing: [how to test.md](documentation/how%20to%20test.md)
- Troubleshooting: [troubleshooting.md](documentation/troubleshooting.md)
- Git sync helper: [how to use sync-git.md](documentation/how%20to%20use%20sync-git.md)
- File sync and ownership: [file sync and ownership.md](documentation/file%20sync%20and%20ownership.md)
- Image cleanup: [how to clean devcontainer images.md](documentation/how%20to%20clean%20devcontainer%20images.md)
- Devcontainer CLI: [how to use devcontainer cli.md](documentation/how%20to%20use%20devcontainer%20cli.md)
- Claude Code: [how to use claude.md](documentation/how%20to%20use%20claude.md)
- Devcontainer scripts: [.devcontainer/scripts/README.md](.devcontainer/scripts/README.md)

## Helpful Scripts

- Devcontainer launcher: `./editor-launch.sh`
- CLI shell into container: `./devcontainer-launch.sh`
- Claude Code launcher: `./claude-launch.sh`
- Git sync helper: `./scripts/sync-git.sh`
- Devcontainer image cleanup: `./scripts/clean-devcontainer-images.sh`
- SSH and Git verifier (in container): `./.devcontainer/scripts/verify-git-ssh.sh`

## Why do I have this project?

In the last few years I have been using Visual Studio Code, and I like to use as much containers as I can, instead of setting up environments for Python or things like that.

Devcontainers is pretty handy for that, and it is just a short step to move it into a deployment when I am done.

I found myself recreating a similar setup each time, with more or less features each time, and this is an attempt to simplify that step.

I am thinking of creating a few different devcontainers, each based on a previous iteration (although I don't like inheritance, in this case seems to be valuable).

This is the first run. Just Ubuntu (my remote deployments are usually containers based in Ubuntu) with git and some editing tools (Markdown validation, some git shortcuts, and that is it).

VS Code is also configured to use the validation tools by way of extensions, and they also hang as command line tools (although I don't use them regularly).

An extra situation is that I have also a Synology NAS where I synchronise my files. I commit to git when ready, but I like to be able to continue working in any of my machines and have them in sync automatically. Synology Drive is good for that.

However, there are some tricky cases around file ownership (I use Ubuntu 24.10 at the moment in my own machines). Depending on where the files are created (the workstation or inside the container), Synology gets confused and start to cause troubles around the synchronisation process.

A way around it is to use the same user inside the container as it is outside. A launch script takes care of that details passing activity, and all the files seems to be updated correctly now.

I want to be able to use Git inside and out of the container, then I also pass the ssh credentials to my Git remote repository to syncronise at will. That also seems to be working correctly.
