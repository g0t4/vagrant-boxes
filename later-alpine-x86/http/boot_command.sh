#!ash
set -x

# disable bundled ssh service? # IIUC openssh used instead, setup below
sed -i -e "/rc-service/d" /sbin/setup-sshd

source answer_file.cfg

# start alpine's auto install
# - passing root password = vagrant
printf "vagrant\nvagrant\ny\n" \
  | sh /sbin/setup-alpine -f /root/answer_file.cfg

# presumably /dev/sda2 was install target (filesystem)
# - make following changes before rebooting from /dev/sda
mount /dev/sda2 /mnt

# delete existing PermitRootLogin and PasswordAuthentication lines
# note: alpine's sed isn't same args as macOS's:
sed -E -i '/#? ?PasswordAuthentication/d' /mnt/etc/ssh/sshd_config
sed -E -i '/#? ?PermitRootLogin/d' /mnt/etc/ssh/sshd_config
# add exact lines to enable both:
echo 'PasswordAuthentication yes' >>/mnt/etc/ssh/sshd_config
echo 'PermitRootLogin yes' >>/mnt/etc/ssh/sshd_config

chroot /mnt apk add openntpd
chroot /mnt rc-update add openntpd default

# reboot

#### NOTES
# - see /sbin/setup-* functions used above
#   - `grep -A10 -B10 ERASE_DISKS /sbin/setup-*`
#     - find what uses what
# - currently uses auto install via setup-alpine
#   - https://docs.alpinelinux.org/user-handbook/0.1a/Installing/setup_alpine.html
# - could also use semi-auto install
#   = bypass setup-alpine and call out to multiple setup-X functions
#   - https://docs.alpinelinux.org/user-handbook/0.1a/Installing/manual.html
