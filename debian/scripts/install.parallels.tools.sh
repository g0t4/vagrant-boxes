#!/bin/sh -eux

sudo mkdir -p /tmp/parallels

sudo mount -o loop /home/vagrant/prl-tools-lin-arm.iso /tmp/parallels

# PRN - install dependencies (right now not missing with ubuntu 22.04.1)
sudo /tmp/parallels/install --install-unattended-with-deps
# check logs on failures: /var/log/parallels-tools-install.log;

# cleanup
sudo umount /tmp/parallels
sudo rm -rf /tmp/parallels
sudo rm -f /home/vagrant/*.iso
