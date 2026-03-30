#!/bin/sh -eux

# Sync and full system upgrade
sudo pacman -Syu --noconfirm

# Install packages
sudo pacman -S --noconfirm --needed \
  bat \
  bash-completion \
  curl \
  dust \
  fzf \
  fish \
  git \
  git-delta \
  git-lfs \
  grc \
  httpie \
  hwinfo \
  jq \
  less \
  lshw \
  most \
  neovim \
  nmap \
  iproute2 \
  lsof \
  procps-ng \
  psmisc \
  ripgrep \
  strace \
  tree \
  trash-cli \
  unzip \
  uv \
  util-linux \
  vim \
  wget \
  which

# Clean package cache
sudo pacman -Scc --noconfirm
