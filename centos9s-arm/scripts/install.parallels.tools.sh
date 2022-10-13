#!/bin/bash -eux

# pre-reqs (several already installed, include to be sure)
#   from https://kb.parallels.com/en/118876
dnf --assumeyes install sudo tar gcc checkpolicy selinux-policy-devel \
  kernel-devel-$(uname -r) kernel-headers-$(uname -r) make

mkdir -p /tmp/parallels

# NOTE: path to parallels tools depends on user logged in
mount -o loop /root/prl-tools-lin-arm.iso /tmp/parallels

/tmp/parallels/install --install-unattended-with-deps
# check logs on failures: /var/log/parallels-tools-install.log;

# cleanup
umount /tmp/parallels
rm -rf /tmp/parallels
rm -f /root/*.iso
