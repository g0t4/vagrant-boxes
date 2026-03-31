#!/bin/sh -eux

# Sync and full system upgrade
sudo pacman -Syu --noconfirm

# Install packages
sudo pacman -S --noconfirm --needed \
  bat \
  bash-completion \
  dust \
  fzf \
  git-delta \
  git-lfs \
  grc \
  httpie \
  jq \
  lshw \
  most \
  nmap \
  lsof \
  procps-ng \
  psmisc \
  ripgrep \
  strace \
  trash-cli \
  unzip \
  uv \
  util-linux \
  wget \
  which

# aarch64 has no `hwinfo` pkg

# Clean package cache
sudo pacman -Scc --noconfirm
