#!/bin/bash -eux

# from https://github.com/lavabit/robox/blob/master/scripts/centos9s/cleanup.sh

echo "Remove the ethernet identity values.\n"
if [ -f /etc/sysconfig/network-scripts/ifcfg-eth0 ]; then
  sed -i /UUID/d /etc/sysconfig/network-scripts/ifcfg-eth0
  sed -i /HWADDR/d /etc/sysconfig/network-scripts/ifcfg-eth0
fi

# Clear the random seed.
rm -f /var/lib/systemd/random-seed
