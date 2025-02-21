FROM ubuntu:22.04

# Add labels for better container management
LABEL maintainer="Eduardo Shanahan"
LABEL description="Development container for Git in Ubuntu"

# Prevent interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Set timezone
ENV TZ=UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Arguments for editor choice
ARG EDITOR_CHOICE=code

# Install dependencies
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
    git \
    curl \
    build-essential \
    sudo \
    vim \
    nano \
    wget \
    zip \
    unzip \
    tree \
    htop \
    jq \
    bash-completion \
    ca-certificates \
    gnupg \
    lsb-release \
    locales \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Set the locale
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Arguments for user and Git configuration
ARG HOST_USERNAME
ARG HOST_UID
ARG HOST_GID
ARG GIT_USER_NAME
ARG GIT_USER_EMAIL

# Create group and user with secure defaults
RUN groupadd --gid $HOST_GID $HOST_USERNAME \
    && useradd --uid $HOST_UID --gid $HOST_GID -m $HOST_USERNAME \
    && echo "$HOST_USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers \
    && mkdir -p /etc/sudoers.d \
    && echo "$HOST_USERNAME ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$HOST_USERNAME \
    && chmod 0440 /etc/sudoers.d/$HOST_USERNAME

# Switch to the new user
USER $HOST_USERNAME

# Set the working directory
WORKDIR /workspace

# Configure Git with useful defaults
RUN if [ "$EDITOR_CHOICE" = "cursor" ]; then \
    git config --global core.editor "cursor --wait"; \
    else \
    git config --global core.editor "code --wait"; \
    fi && \
    git config --global user.name "${GIT_USER_NAME}" && \
    git config --global user.email "${GIT_USER_EMAIL}" && \
    git config --global init.defaultBranch main && \
    git config --global core.autocrlf input && \
    git config --global pull.rebase false && \
    git config --global color.ui auto && \
    git config --global core.fileMode true && \
    git config --global help.autocorrect 1

# Setup bash configuration
RUN echo 'export PS1="\[\033[01;32m\]\u@devcontainer\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ "' >> ~/.bashrc && \
    echo 'export HISTSIZE=5000' >> ~/.bashrc && \
    echo 'export HISTFILESIZE=10000' >> ~/.bashrc && \
    echo 'export HISTCONTROL=ignoreboth' >> ~/.bashrc && \
    echo 'export HISTTIMEFORMAT="%F %T "' >> ~/.bashrc && \
    echo 'alias ll="ls -la"' >> ~/.bashrc && \
    echo 'alias ls="ls --color=auto"' >> ~/.bashrc && \
    echo 'alias grep="grep --color=auto"' >> ~/.bashrc && \
    echo 'alias gs="git status"' >> ~/.bashrc && \
    echo 'alias gp="git pull"' >> ~/.bashrc && \
    echo 'alias gd="git diff"' >> ~/.bashrc && \
    echo 'alias gc="git commit"' >> ~/.bashrc && \
    echo 'alias gb="git branch"' >> ~/.bashrc && \
    echo 'alias gl="git log --oneline --graph --decorate"' >> ~/.bashrc && \
    echo 'alias gco="git checkout"' >> ~/.bashrc && \
    echo 'alias gf="git fetch --all --prune"' >> ~/.bashrc && \
    echo 'alias gst="git stash"' >> ~/.bashrc && \
    echo 'alias gstp="git stash pop"' >> ~/.bashrc && \
    echo 'source /etc/bash_completion' >> ~/.bashrc
