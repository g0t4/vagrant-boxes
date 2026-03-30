#!/bin/bash -eux

# Arch Linux installation script
# Runs from archboot live environment (bash prompt after Ctrl+C)
# Partitions /dev/sda, installs base system, configures, reboots into installed system
# Packer then SSHes into the installed system as vagrant to run provisioner scripts

# ===== DISK SETUP =====
# Parallels presents the virtual disk as /dev/sda
# GPT with EFI System Partition + root
# Note: parted not available in archboot, use fdisk

fdisk /dev/sda << 'FDISK'
g
n
1

+512M
t
1
n
2


w
FDISK

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
  fish \
  archlinuxarm-keyring

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

# Trust the Arch Linux ARM signing key
# (pacstrap -K only initializes the standard archlinux keyring, not archlinuxarm)
pacman-key --populate archlinuxarm
# without trusting this key, pacman installs will fail after rebooting into new machine

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

CHROOT

# ===== GRUB CONFIG =====
# grub-mkconfig doesn't detect ARM64 kernel (looks for vmlinuz-linux, but ARM64 uses Image)
# Write grub.cfg manually with UUIDs from freshly formatted partitions
EFI_UUID=$(blkid -s UUID -o value /dev/sda1)
ROOT_UUID=$(blkid -s UUID -o value /dev/sda2)
cat > /mnt/boot/grub/grub.cfg << EOF
set default=0
set timeout=1

menuentry 'Arch Linux' {
    search --no-floppy --fs-uuid --set=root $EFI_UUID
    linux /Image root=UUID=$ROOT_UUID rw quiet
    initrd /initramfs-linux.img
}

menuentry 'Arch Linux (fallback)' {
    search --no-floppy --fs-uuid --set=root $EFI_UUID
    linux /Image root=UUID=$ROOT_UUID rw
    initrd /initramfs-linux-fallback.img
}
EOF

# ===== DONE =====
umount -R /mnt
reboot
