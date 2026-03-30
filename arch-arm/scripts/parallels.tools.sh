#!/bin/sh -eux

# Install kernel headers first (needed to build parallels kernel module)
sudo pacman -S --noconfirm --needed linux-headers

sudo mkdir -p /tmp/parallels

sudo mount -o loop /home/vagrant/prl-tools-lin-arm.iso /tmp/parallels

sudo /tmp/parallels/install --install-unattended-with-deps
# check logs on failures: /var/log/parallels-tools-install.log

# cleanup
sudo umount /tmp/parallels
sudo rm -rf /tmp/parallels
sudo rm -f /home/vagrant/*.iso
