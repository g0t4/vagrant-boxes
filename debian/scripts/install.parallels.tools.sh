#!/bin/sh -eux

# FYI bento uses dmidecode package to check if in parallels VM to conditionally run this script, if I move to multiple hypervisor builds I can try this approach if it makes packer build easier (ie no need to use vars in packer config to select what scripts to run?):
# https://github.com/lavabit/robox/blob/eadba7cd7a3aa58e6f6f2f3e92fc51585ab2828b/scripts/debian12/parallels.sh#L30-L40

sudo mkdir -p /tmp/parallels

sudo mount -o loop /home/vagrant/prl-tools-lin-arm.iso /tmp/parallels

# PRN - install dependencies (right now not missing with ubuntu 22.04.1)
sudo /tmp/parallels/install --install-unattended-with-deps
# check logs on failures: /var/log/parallels-tools-install.log;

# cleanup
sudo umount /tmp/parallels
sudo rm -rf /tmp/parallels
sudo rm -f /home/vagrant/*.iso
