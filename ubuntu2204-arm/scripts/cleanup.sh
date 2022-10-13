#!/bin/sh -eux

# haven't noticed any large log files (most are <10K)
# + install logs may be useful if anyone has trouble (i.e. parallel tools)
# so I'm not going to clean any up

# Remove the random seed so a unique value is used the first time the box is booted.
sudo systemctl --quiet is-active systemd-random-seed.service 
sudo systemctl stop systemd-random-seed.service
[ -f /var/lib/systemd/random-seed ] && sudo rm --force /var/lib/systemd/random-seed

# TODO disable vagrant:password external access like centos9s-arm