# Use the official Ubuntu 22.04 image as a base
FROM ubuntu:22.04

# Install basic dependencies
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    ca-certificates \
    curl \
    git \
    git-filter-repo \
    build-essential \
    openssh-client \
    jq \
    ripgrep \
    wget \
    locales \
    && rm -rf /var/lib/apt/lists/*

# Install Starship
RUN curl -sS https://starship.rs/install.sh | sh -s -- --yes

# Set the working directory
WORKDIR /workspace

ARG LOCALE
ARG USERNAME
ARG USER_UID
ARG USER_GID

# Configure locale (must be defined via build args)
RUN test -n "$LOCALE" \
    && grep -Eq "^[# ]*$LOCALE[[:space:]]+UTF-8" /etc/locale.gen \
    && sed -i "s/^# *$LOCALE[[:space:]]\\+UTF-8/$LOCALE UTF-8/" /etc/locale.gen \
    && locale-gen

ENV LANG=$LOCALE \
    LANGUAGE=$LOCALE \
    LC_ALL=$LOCALE

# Create the user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && apt-get update \
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# Ensure bash is the default shell for the user
RUN chsh -s /bin/bash $USERNAME

# Ensure prompt setup is sourced in interactive shells
RUN printf '\n# Devcontainer prompt\nif [ -f /workspace/.devcontainer/scripts/bash-prompt.sh ]; then\n  . /workspace/.devcontainer/scripts/bash-prompt.sh\nfi\n' >> /etc/bash.bashrc

# Ensure login shells also source the prompt setup
RUN printf '%s\n' '#!/bin/sh' \
    'if [ -f /workspace/.devcontainer/scripts/bash-prompt.sh ]; then' \
    '  . /workspace/.devcontainer/scripts/bash-prompt.sh' \
    'fi' \
    > /etc/profile.d/devcontainer-prompt.sh \
    && chmod 0644 /etc/profile.d/devcontainer-prompt.sh

# Entry point to run post-stop logic on container shutdown
COPY scripts/devcontainer-entrypoint.sh /usr/local/bin/devcontainer-entrypoint.sh
RUN chmod 0755 /usr/local/bin/devcontainer-entrypoint.sh

# Set ownership of workspace
RUN chown $USERNAME:$USERNAME /workspace

ENTRYPOINT ["/usr/local/bin/devcontainer-entrypoint.sh"]
