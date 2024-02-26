#!/bin/bash -eux

# from https://github.com/lavabit/robox/blob/master/scripts/centos9s/cleanup.sh

echo "Remove the ethernet identity values.\n"
if [ -f /etc/sysconfig/network-scripts/ifcfg-eth0 ]; then
  sed -i /UUID/d /etc/sysconfig/network-scripts/ifcfg-eth0
  sed -i /HWADDR/d /etc/sysconfig/network-scripts/ifcfg-eth0
fi

# Remove the random seed so a unique value is used the first time the box is booted.
sudo systemctl --quiet is-active systemd-random-seed.service
sudo systemctl stop systemd-random-seed.service
[ -f /var/lib/systemd/random-seed ] && sudo rm --force /var/lib/systemd/random-seed

# todo /etc/machine-id