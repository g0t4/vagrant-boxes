text --non-interactive # --non-interactive kills install if any answers missing
reboot --eject # reboot after install
lang en_US.UTF-8
keyboard us
timezone US/Pacific

rootpw --plaintext vagrant # set root password
user --name=vagrant --password=vagrant --plaintext # create vagrant user

zerombr
autopart

firewall --enabled --service=ssh 
authconfig --enableshadow --passalgo=sha512
# todo use authselect instead of deprecated authconfig
network --device eth0 --bootproto dhcp --noipv6 --hostname=centos9s.localdomain
bootloader --timeout=1 --append="net.ifnames=0 biosdevname=0 no_timer_check vga=792 nomodeset text"

%packages
@core
sudo
authconfig
-fprintd-pam
-intltool
-iwl*-firmware
-microcode_ctl
%end

%post
# Create the vagrant user account. TODO isn't this redundant?
/usr/sbin/useradd vagrant
echo "vagrant" | passwd --stdin vagrant

# Make the future vagrant user a sudo master.
sed -i "s/^.*requiretty/#Defaults requiretty/" /etc/sudoers
echo "vagrant        ALL=(ALL)       NOPASSWD: ALL" >>/etc/sudoers.d/vagrant
chmod 0440 /etc/sudoers.d/vagrant

# permit ssh root login w/ password - for provisioning only # disabled in last provisioning script
sed -i -e "s/.*PermitRootLogin.*/PermitRootLogin yes/g" /etc/ssh/sshd_config
sed -i -e "s/.*PasswordAuthentication.*/PasswordAuthentication yes/g" /etc/ssh/sshd_config

cat <<-EOF >/etc/udev/rules.d/60-scheduler.rules
# Set the default scheduler for various device types and avoid the buggy bfq scheduler.
ACTION=="add|change", KERNEL=="sd[a-z]|sg[a-z]|vd[a-z]|hd[a-z]|xvd[a-z]|dm-*|mmcblk[0-9]*|nvme[0-9]*", ATTR{queue/scheduler}="mq-deadline"
EOF
%end
