#!/bin/bash -eux

# from https://github.com/lavabit/robox/blob/master/scripts/centos9s/cleanup.sh

echo "Remove the ethernet identity values.\n"
if [ -f /etc/sysconfig/network-scripts/ifcfg-eth0 ]; then
  sed -i /UUID/d /etc/sysconfig/network-scripts/ifcfg-eth0
  sed -i /HWADDR/d /etc/sysconfig/network-scripts/ifcfg-eth0
fi

# Remove packages only required for provisioning purposes and then dump the repository cache.
dnf --quiet --assumeyes clean all

# Remove the installation logs.
rm --force /root/anaconda-ks.cfg /root/original-ks.cfg /root/install.log /root/install.log.syslog /var/log/yum.log /var/log/dnf.log

if [ -d /var/log/anaconda/ ]; then
  rm --force --recursive /var/log/anaconda/
fi

# Clear the random seed.
rm -f /var/lib/systemd/random-seed

# Truncate the log files.
echo "Truncate the log files.\n"
find /var/log -type f -exec truncate --size=0 {} \;

# Wipe the temp directory.
echo "Purge the setup files and temporary data.\n"
rm --recursive --force /var/tmp/* /tmp/* /var/cache/dnf/* /tmp/ks-script*

# Clear the command history.
history -c
# clear vagrant user's history too
rm -f /home/vagrant/.bash_history
