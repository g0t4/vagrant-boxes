
source "virtualbox-iso" "generic-alpine316-virtualbox" {
  boot_command = [
    "<enter><wait10>",
    "root<enter><wait>",
    "ifconfig eth0 up && udhcpc -i eth0<enter><wait>",
    "wget http://{{ .HTTPIP }}:{{ .HTTPPort }}/generic.alpine316.vagrant.cfg<enter><wait>",
    "sed -i -e \"/rc-service/d\" /sbin/setup-sshd<enter><wait>",
    "source generic.alpine316.vagrant.cfg<enter><wait>",
    "printf \"vagrant\\nvagrant\\ny\\n\" | sh /sbin/setup-alpine -f /root/generic.alpine316.vagrant.cfg && ",
    "mount /dev/sda2 /mnt && ",
    "sed -E -i '/#? ?PasswordAuthentication/d' /mnt/etc/ssh/sshd_config && ",
    "sed -E -i '/#? ?PermitRootLogin/d' /mnt/etc/ssh/sshd_config && ",
    "echo 'PasswordAuthentication yes' >> /mnt/etc/ssh/sshd_config && ",
    "echo 'PermitRootLogin yes' >> /mnt/etc/ssh/sshd_config && ",
    "chroot /mnt apk add openntpd && chroot /mnt rc-update add openntpd default && reboot<enter>"
  ]
  boot_keygroup_interval  = "1s"
  boot_wait               = "60s"
  cpus                    = 2
  disk_size               = 131072
  guest_additions_mode    = "upload"
  guest_additions_path    = "VBoxGuestAdditions.iso"
  guest_additions_sha256  = "c987cdc8c08c579f56d921c85269aeeac3faf636babd01d9461ce579c9362cdd"
  guest_additions_url     = "https://download.virtualbox.org/virtualbox/6.1.36/VBoxGuestAdditions_6.1.36.iso"
  guest_os_type           = "Linux_64"
  hard_drive_interface    = "sata"
  headless                = true
  http_directory          = "http"
  iso_checksum            = "sha256:6c7cb998ec2c8925d5a1239410a4d224b771203f916a18f8015f31169dd767a2"
  iso_url                 = "https://mirrors.edge.kernel.org/alpine/v3.16/releases/x86_64/alpine-virt-3.16.2-x86_64.iso"
  memory                  = 2048
  output_directory        = "output/generic-alpine316-virtualbox"
  shutdown_command        = "/sbin/poweroff"
  ssh_password            = "vagrant"
  ssh_port                = 22
  ssh_timeout             = "3600s"
  ssh_username            = "root"
  vboxmanage              = [["modifyvm", "{{ .Name }}", "--vram", "64"]]
  virtualbox_version_file = "VBoxVersion.txt"
  vm_name                 = "generic-alpine316-virtualbox"
  vrdp_bind_address       = "127.0.0.1"
  vrdp_port_max           = 12000
  vrdp_port_min           = 11000
}

build {
  sources = ["source.virtualbox-iso.generic-alpine316-virtualbox"]

  provisioner "shell" {
    execute_command   = "/bin/sh '{{ .Path }}'"
    expect_disconnect = "true"
    only              = ["generic-alpine316-virtualbox"]
    scripts = [
      "scripts/alpine316/network.sh",
      "scripts/alpine316/apk.sh"
    ]
    start_retry_timeout = "15m"
    timeout             = "2h0m0s"
  }

  provisioner "shell" {
    execute_command   = "{{ .Vars }} /bin/bash '{{ .Path }}'"
    expect_disconnect = "true"
    only              = ["generic-alpine316-virtualbox"]
    pause_before      = "2m0s"
    scripts = [
      "scripts/alpine316/hostname.sh",
      "scripts/alpine316/lsb.sh",
      "scripts/alpine316/floppy.sh",
      "scripts/alpine316/vagrant.sh",
      "scripts/alpine316/sshd.sh",
      "scripts/alpine316/virtualbox.sh",
      "scripts/alpine316/parallels.sh",
      "scripts/alpine316/vmware.sh",
      "scripts/alpine316/qemu.sh",
      "scripts/alpine316/cache.sh"
    ]
    start_retry_timeout = "15m"
    timeout             = "2h0m0s"
  }

}
