#!/bin/bash -eux

# Arch Linux installation script
# Runs from archboot live environment (rescue.target shell)
# Partitions /dev/sda, installs base system, configures, reboots into installed system
# Packer then SSHes into the installed system as vagrant to run provisioner scripts

# ===== DISK SETUP =====
# Parallels presents the virtual disk as /dev/sda
# GPT with EFI System Partition + root

parted --script /dev/sda \
  mklabel gpt \
  mkpart ESP fat32 1MiB 512MiB \
  set 1 esp on \
  mkpart primary ext4 512MiB 100%

# Give kernel a moment to see new partition table
sleep 2

mkfs.fat -F32 /dev/sda1
mkfs.ext4 -F /dev/sda2

# Mount: /boot = EFI partition, / = root
mount /dev/sda2 /mnt
mkdir -p /mnt/boot
mount /dev/sda1 /mnt/boot

# ===== BASE INSTALL =====
# -K initializes pacman keyring fresh (required for clean install environments)
pacstrap -K /mnt \
  base \
  linux \
  linux-firmware \
  linux-headers \
  grub \
  efibootmgr \
  networkmanager \
  openssh \
  sudo \
  curl \
  git \
  vim \
  fish

genfstab -U /mnt >>/mnt/etc/fstab

# ===== SYSTEM CONFIGURATION =====
arch-chroot /mnt /bin/bash -eux <<'CHROOT'

# Timezone + clock
ln -sf /usr/share/zoneinfo/UTC /etc/localtime
hwclock --systohc

# Locale
echo "en_US.UTF-8 UTF-8" >>/etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >/etc/locale.conf

# Hostname
echo "arch" >/etc/hostname
cat >>/etc/hosts <<'HOSTS'
127.0.0.1   localhost
::1         localhost
127.0.1.1   arch.localdomain arch
HOSTS

# Networking
systemctl enable NetworkManager

# SSH - enable and allow password auth for packer to connect
systemctl enable sshd
sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Vagrant user
useradd -m -G wheel -s /bin/bash vagrant
echo "vagrant:vagrant" | chpasswd

# Passwordless sudo for wheel
echo "%wheel ALL=(ALL:ALL) NOPASSWD: ALL" >/etc/sudoers.d/wheel
chmod 440 /etc/sudoers.d/wheel

# GRUB for ARM64 EFI (/boot is the EFI partition)
grub-install --target=arm64-efi --efi-directory=/boot --bootloader-id=GRUB --recheck
grub-mkconfig -o /boot/grub/grub.cfg

CHROOT

# ===== DONE =====
umount -R /mnt
reboot
