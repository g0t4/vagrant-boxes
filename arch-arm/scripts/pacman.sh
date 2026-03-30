#!/bin/sh -eux

# Sync and full system upgrade
sudo pacman -Syu --noconfirm

# Install packages
sudo pacman -S --noconfirm --needed \
  bash-completion \
  curl \
  fish \
  git \
  grc \
  iproute2 \
  lsof \
  procps-ng \
  psmisc \
  the_silver_searcher \
  tree \
  util-linux \
  vim \
  wget

# Clean package cache
sudo pacman -Scc --noconfirm
