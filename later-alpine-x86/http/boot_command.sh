#!ash

# disable bundled ssh service? # IIUC openssh used instead, setup below
sed -i -e "/rc-service/d" /sbin/setup-sshd

# env vars used by setup-alpine:
export KEYMAPOPTS="us us"
export HOSTNAMEOPTS="-n alpine316.localdomain" # set hostname
export INTERFACESOPTS="auto lo
iface lo inet loopback

auto eth0
iface eth0 inet dhcp
    hostname alpine316.localdomain
" # enable loopback + dhcp for eth0
export DNSOPTS="-d local -n 1.1.1.1" # use cloudflare DNS (much faster on my network)
export TIMEZONEOPTS="-z UTC" # UTC timezone
export PROXYOPTS="none"
export APKREPOSOPTS="https://mirrors.edge.kernel.org/alpine/v3.16/main" # use "-r" for random mirror
export SSHDOPTS="-c openssh" # install openssh
export NTPOPTS="-c none" # disable NTP # todo NTPOPTS="-c openntpd" # install openntpd
export ERASE_DISKS="/dev/sda" # prepare disk # used in /sbin/setup-disk
export DISKOPTS="-s 0 -m sys /dev/sda" #

printf "vagrant\nvagrant\ny\n" \
  | sh /sbin/setup-alpine -f /root/generic.alpine316.vagrant.cfg

mount /dev/sda2 /mnt

# todo escaping?
sed -E -i '/#? ?PasswordAuthentication/d' /mnt/etc/ssh/sshd_config
sed -E -i '/#? ?PermitRootLogin/d' /mnt/etc/ssh/sshd_config

echo 'PasswordAuthentication yes' >>/mnt/etc/ssh/sshd_config
echo 'PermitRootLogin yes' >>/mnt/etc/ssh/sshd_config

chroot /mnt apk add openntpd
chroot /mnt rc-update add openntpd default

reboot

#### NOTES
# - see /sbin/setup-* functions used above
#   - `grep -A10 -B10 ERASE_DISKS /sbin/setup-*`
#     - find what uses what
# - currently uses auto install via setup-alpine
#   - https://docs.alpinelinux.org/user-handbook/0.1a/Installing/setup_alpine.html
# - could also use semi-auto install
#   = bypass setup-alpine and call out to multiple setup-X functions
#   - https://docs.alpinelinux.org/user-handbook/0.1a/Installing/manual.html
