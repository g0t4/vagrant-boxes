#!/bin/bash -eux

# blank machine-id so each VM gets a unique ID generated on first boot
sudo truncate -s 0 /etc/machine-id
if test -f /var/lib/dbus/machine-id; then
  sudo truncate -s 0 /var/lib/dbus/machine-id
fi

# Remove random seed so a fresh unique value is generated on first boot
sudo systemctl --quiet is-active systemd-random-seed.service && sudo systemctl stop systemd-random-seed.service
[ -f /var/lib/systemd/random-seed ] && sudo rm --force /var/lib/systemd/random-seed
