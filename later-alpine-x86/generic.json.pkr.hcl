
# virtualbox-iso builder # https://developer.hashicorp.com/packer/plugins/builders/virtualbox/iso
source "virtualbox-iso" "alpine316-x86-virtualbox" {
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
  disk_size               = 131072 # 128 MB
  guest_additions_mode    = "upload"
  guest_additions_path    = "VBoxGuestAdditions.iso"
  guest_additions_sha256  = "9cf5413399f59cfa4ba9ed89a9295b1b2ef3b997cb526a100637b5c59a526872" # https://download.virtualbox.org/virtualbox/7.0.2/SHA256SUMS
  guest_additions_url     = "https://download.virtualbox.org/virtualbox/7.0.2/VBoxGuestAdditions_7.0.2.iso"
  guest_os_type           = "Linux" # 32-bit generic Linux # VBoxManage list ostypes
  hard_drive_interface    = "sata"
  headless                = true
  http_directory          = "http"
  iso_checksum            = "file:https://mirrors.edge.kernel.org/alpine/v3.16/releases/x86/alpine-virt-3.16.2-x86.iso.sha256"
  iso_url                 = "https://mirrors.edge.kernel.org/alpine/v3.16/releases/x86/alpine-virt-3.16.2-x86.iso"
  memory                  = 2048 # 2 GB
  output_directory        = "output/alpine316-x86-virtualbox"
  shutdown_command        = "/sbin/poweroff"
  ssh_password            = "vagrant"
  ssh_port                = 22
  ssh_timeout             = "3600s"
  ssh_username            = "root"
  vboxmanage              = [["modifyvm", "{{ .Name }}", "--vram", "64"]]
  # todo modify arch - disable paravirt, nested paging - use ICH9 chipset
  vm_name                 = "alpine316-x86-virtualbox"
}

build {
  sources = ["source.virtualbox-iso.alpine316-x86-virtualbox"]

  provisioner "shell" {
    execute_command   = "/bin/sh '{{ .Path }}'"
    expect_disconnect = "true"
    only              = ["alpine316-x86-virtualbox"]
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
    only              = ["alpine316-x86-virtualbox"]
    pause_before      = "2m0s"
    scripts = [
      "scripts/alpine316/hostname.sh",
      "scripts/alpine316/lsb.sh",
      "scripts/alpine316/floppy.sh",
      "scripts/alpine316/vagrant.sh",
      "scripts/alpine316/sshd.sh",
      "scripts/alpine316/virtualbox.sh",
      "scripts/alpine316/cache.sh"
    ]
    start_retry_timeout = "15m"
    timeout             = "2h0m0s"
  }

  post-processor "vagrant" {
    output = "out/packer_{{.BuildName}}_{{.Provider}}.box" # the default
    include           = ["info.json"]
    compression_level = 9 # default = 6
    #    "vagrantfile_template": "tpl/generic-{{split build_name \"-\" 1}}.rb"
  }
}
