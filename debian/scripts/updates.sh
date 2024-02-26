#!/bin/sh -eux

# copied/modified from:
# bento: https://github.com/chef/bento/blob/master/packer_templates/scripts/debian/update_debian.sh
# robox: https://github.com/lavabit/robox/blob/master/scripts/debian12/apt.sh

export DEBIAN_FRONTEND=noninteractive
export DEBCONF_NONINTERACTIVE_SEEN=true



# avoid deadlock during install:
systemctl stop apt-daily.timer;
systemctl stop apt-daily-upgrade.timer;
# TODO do I really wanna disable apt timers/services for VMs booted from this box?
# disable apt timers/services so they don't run on VMs booted from this box too:
systemctl disable apt-daily.timer;
systemctl disable apt-daily-upgrade.timer;
systemctl mask apt-daily.service;
systemctl mask apt-daily-upgrade.service;
systemctl daemon-reload;
# FYI don't modify default cleanup config, that way if someone wants to enable it, it's still there:
#  /etc/apt/apt.conf.d/10periodic


apt-get update
apt-get dist-upgrade -y
apt-get autoremove -y
apt-get autoclean -y

# TODO update kernel+headers?
# arch="$(uname -r | sed 's/^.*[0-9]\{1,\}\.[0-9]\{1,\}\.[0-9]\{1,\}\(-[0-9]\{1,2\}\)-//')"
# apt-get -y upgrade linux-image-"$arch";
# apt-get -y install linux-headers-"$(uname -r)";

# TODO add any packages I want on all instances of this box:
#  mlocate? (review config for this in bento too)
