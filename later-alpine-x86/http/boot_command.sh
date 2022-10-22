#!ash

# delete line # rc-service $svc start
sed -i -e "/rc-service/d" /sbin/setup-sshd

# env vars used by setup-alpine:
export KEYMAPOPTS="us us"
export HOSTNAMEOPTS="-n alpine316.localdomain"
export INTERFACESOPTS="auto lo
iface lo inet loopback

auto eth0
iface eth0 inet dhcp
    hostname alpine316.localdomain
"
export DNSOPTS="-d local -n 4.2.2.1 4.2.2.2 208.67.220.220"
export TIMEZONEOPTS="-z UTC"
export PROXYOPTS="none"
export APKREPOSOPTS="https://mirrors.edge.kernel.org/alpine/v3.16/main"
export SSHDOPTS="-c openssh"
export NTPOPTS="-c none"
export ERASE_DISKS="/dev/sda"
export DISKOPTS="-s 0 -m sys /dev/sda"


printf "vagrant\nvagrant\ny\n" \
  | sh /sbin/setup-alpine -f /root/generic.alpine316.vagrant.cfg

mount /dev/sda2 /mnt

# todo escaping?
sed -E -i '/#? ?PasswordAuthentication/d' /mnt/etc/ssh/sshd_config
sed -E -i '/#? ?PermitRootLogin/d' /mnt/etc/ssh/sshd_config

echo 'PasswordAuthentication yes' >> /mnt/etc/ssh/sshd_config
echo 'PermitRootLogin yes' >> /mnt/etc/ssh/sshd_config

chroot /mnt apk add openntpd
chroot /mnt rc-update add openntpd default

reboot


#### NOTES
# - currently uses auto install via setup-alpine
#   - https://docs.alpinelinux.org/user-handbook/0.1a/Installing/setup_alpine.html
# - could also use semi-auto install
#   = bypass setup-alpine and call out to multiple setup-X functions 
#   - https://docs.alpinelinux.org/user-handbook/0.1a/Installing/manual.html

