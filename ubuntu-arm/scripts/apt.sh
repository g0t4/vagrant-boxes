#!/bin/sh -eux

# sync with debian/scripts/apt.sh

# avoid deadlock during install:
sudo systemctl stop \
  apt-daily.timer \
  apt-daily-upgrade.timer \
  apt-daily.service \
  apt-daily-upgrade.service

# disable apt timers/services so they don't run on VMs booted from this box too:
sudo systemctl disable \
  apt-daily.timer \
  apt-daily-upgrade.timer \
  apt-daily.service \
  apt-daily-upgrade.service
sudo systemctl mask \
  apt-daily.service \
  apt-daily-upgrade.service \
  apt-daily-upgrade.timer \
  apt-daily.timer
sudo systemctl daemon-reload

sudo DEBIAN_FRONTEND=noninteractive apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -y
sudo DEBIAN_FRONTEND=noninteractive apt-get autoremove -y
sudo DEBIAN_FRONTEND=noninteractive apt-get autoclean -y

sudo DEBIAN_FRONTEND=noninteractive apt-get install -y \
  apt-file \
  command-not-found \
  fish \
  grc \
  lsof \
  psmisc \
  silversearcher-ag \
  tree \
  util-linux \
  vim \
  bash-completion \
  iproute2 \
  procps \
  curl wget