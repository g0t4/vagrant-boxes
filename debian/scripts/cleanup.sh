#!/bin/sh -eux

# TODO boot up a machine and don't run the cleanup script, pause the packer build and check size of files on disk that are proposed to be cleaned up in bento's script: https://github.com/chef/bento/blob/master/packer_templates/scripts/debian/cleanup_debian.sh

# haven't noticed any large log files (most are <10K)
# + install logs may be useful if anyone has trouble (i.e. parallel tools)
# so I'm not going to clean any up



# *** from https://github.com/chef/bento/blob/45792040a997156a257660bd3e2d8f6b1209b677/packer_templates/scripts/debian/cleanup_debian.sh#L50-L56
echo "blank netplan machine-id (DUID) so machines get unique ID generated on boot"
truncate -s 0 /etc/machine-id
if test -f /var/lib/dbus/machine-id
then
  truncate -s 0 /var/lib/dbus/machine-id  # if not symlinked to "/etc/machine-id"
fi



# Remove the random seed so a unique value is used the first time the box is booted.
sudo systemctl --quiet is-active systemd-random-seed.service 
sudo systemctl stop systemd-random-seed.service
[ -f /var/lib/systemd/random-seed ] && sudo rm --force /var/lib/systemd/random-seed

# TODO disable vagrant:password external access like centos9s-arm