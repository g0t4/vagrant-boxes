#!ash

sed -i -e \"/rc-service/d\" /sbin/setup-sshd

# todo inline:
source generic.alpine316.vagrant.cfg

printf \"vagrant\\nvagrant\\ny\\n\" \
  | sh /sbin/setup-alpine -f /root/generic.alpine316.vagrant.cfg \
  && mount /dev/sda2 /mnt \
  && sed -E -i '/#? ?PasswordAuthentication/d' /mnt/etc/ssh/sshd_config \
  && sed -E -i '/#? ?PermitRootLogin/d' /mnt/etc/ssh/sshd_config \
  && echo 'PasswordAuthentication yes' >> /mnt/etc/ssh/sshd_config \
  && echo 'PermitRootLogin yes' >> /mnt/etc/ssh/sshd_config \
  && chroot /mnt apk add openntpd \
  && chroot /mnt rc-update add openntpd default \
  && reboot
