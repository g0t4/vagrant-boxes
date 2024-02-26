#!/bin/sh -eux

# copied/modified from:
# bento: https://github.com/chef/bento/blob/master/packer_templates/scripts/debian/update_debian.sh
# robox: https://github.com/lavabit/robox/blob/master/scripts/debian12/apt.sh

export
export DEBCONF_NONINTERACTIVE_SEEN=true

# avoid deadlock during install:
sudo systemctl stop \
  apt-daily.timer \
  apt-daily-upgrade.timer \
  apt-daily.service \
  apt-daily-upgrade.service
# TODO do I really wanna disable apt timers/services for VMs booted from this box?
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
# FYI don't modify default cleanup config, that way if someone wants to enable it, it's still there:
#  /etc/apt/apt.conf.d/10periodic

sudo DEBIAN_FRONTEND=noninteractive apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -y
sudo DEBIAN_FRONTEND=noninteractive apt-get autoremove -y
sudo DEBIAN_FRONTEND=noninteractive apt-get autoclean -y

# TODO add any packages I want on all instances of this box:
#  mlocate? (review config for this in bento too)

# Notes w.r.t. bento/robox:
# - cdrom in /etc/apt/sources.list is commented out so don't worry about it
# - headers/kernel are both installed and upgraded b/c dist-upgrade (robox didn't do dist-upgrade and thus upgrades/installs kernel/headers)

