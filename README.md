# Development Container Template - Just Git

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Docker](https://img.shields.io/badge/Docker-Required-blue)](https://www.docker.com/)
[![VS Code](https://img.shields.io/badge/VS%20Code-Required-blue)](https://code.visualstudio.com/)

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

## Overview
This project serves as a comprehensive template for setting up **Development Containers (Devcontainers)**. It is designed to provide a consistent, reproducible, and containerized development environment, primarily for use with Visual Studio Code, Cursor, or Antigravity.

## Core Problem Solved
The project addresses the challenge of maintaining consistent development environments across multiple machines. It specifically targets issues related to:
- **File Synchronization**: mitigating conflicts when using services like Synology Drive for syncing code between machines.
- **File Ownership**: handling UID/GID mapping to prevent permission issues between the host/container and the synchronization service.
- **Reproducibility**: eliminating "it works on my machine" problems by defining the environment in code.

## Key Features

### 1. Containerized Environment
- Provides a pre-configured `Dockerfile` based on Ubuntu.
- Includes essential development tools:
    - **Git** (with SSH support)
    - **Docker CLI** (for Docker-in-Docker capabilities)
    - **Starship** (for a modern shell prompt)
    - **JSON tools** (`jq`, linters)

### 2. Intelligent Launch System
- Includes a `launch.sh` script that:
    - Validates environment variables (`.env`).
    - Checks for required tools.
    - Launches the user's preferred editor (VS Code, Cursor, or Antigravity).
    - Ensures the local environment is correctly prepped before starting the container.

### 3. Git & SSH Integration
- Seamlessly forwards SSH agents to the container, allowing secure GitHub interactions without storing keys inside the image.
- Automates Git configuration (user name, email) based on environment variables.

### 4. Custom Synchronization
- Features a `sync_git.sh` script to safely manage Git operations in environments where an external file syncer (like Synology Drive) is also active, preventing data corruption or conflicts.

## Usage
Users clone this repository, configure a `.env` file with their specific user details (UID/GID, Git credentials), and use the provided scripts to launch their editor. The editor then reopens the project inside the defined Docker container, providing a fully featured development workspace.