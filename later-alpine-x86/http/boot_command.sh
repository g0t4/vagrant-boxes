#!ash

# delete line # rc-service $svc start
sed -i -e "/rc-service/d" /sbin/setup-sshd

# BEGIN inlined: source generic.alpine316.vagrant.cfg
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
# END inlined

printf "vagrant\nvagrant\ny\n" \
  | sh /sbin/setup-alpine -f /root/generic.alpine316.vagrant.cfg \
  && mount /dev/sda2 /mnt \
  && sed -E -i '/#? ?PasswordAuthentication/d' /mnt/etc/ssh/sshd_config \
  && sed -E -i '/#? ?PermitRootLogin/d' /mnt/etc/ssh/sshd_config \
  && echo 'PasswordAuthentication yes' >> /mnt/etc/ssh/sshd_config \
  && echo 'PermitRootLogin yes' >> /mnt/etc/ssh/sshd_config \
  && chroot /mnt apk add openntpd \
  && chroot /mnt rc-update add openntpd default \
  && reboot
