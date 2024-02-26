#!/bin/sh -eux

# *** from https://github.com/chef/bento/blob/45792040a997156a257660bd3e2d8f6b1209b677/packer_templates/scripts/debian/cleanup_debian.sh#L50-L56
echo "blank netplan machine-id (DUID) so machines get unique ID generated on boot"
truncate -s 0 /etc/machine-id
if test -f /var/lib/dbus/machine-id; then
  truncate -s 0 /var/lib/dbus/machine-id  # if not symlinked to "/etc/machine-id"
fi

# Remove the random seed so a unique value is used the first time the box is booted.
sudo systemctl --quiet is-active systemd-random-seed.service
sudo systemctl stop systemd-random-seed.service
[ -f /var/lib/systemd/random-seed ] && sudo rm --force /var/lib/systemd/random-seed

# TODO disable vagrant:password external access like centos9s-arm

# Notes w.r.t. bento/robox differences:
#   install logs may be useful if anyone has trouble (i.e. parallel tools)
#   /var/cache/apt ~90MB => leave apt packages, presumably the box was built recently and so this saves time to pull all packages each time an instance is created
#   /var/log 33MB
#   /var/tmp 20KB
