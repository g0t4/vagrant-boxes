
# virtualbox-iso builder # https://developer.hashicorp.com/packer/plugins/builders/virtualbox/iso
source "virtualbox-iso" "alpine316-x86-virtualbox" {
  boot_command = [
    "<enter><wait5>",
    "root<enter><wait>",
    # obtain IP via dhcp for eth0:
    "ifconfig eth0 up && udhcpc -i eth0<enter><wait><wait5>",
    # manual testing w/ host only network:
    #   wget http://192.168.56.1:8000/boot.sh
    #   source boot.sh
    "wget http://{{ .HTTPIP }}:{{ .HTTPPort }}/boot_command.sh<enter><wait>",
    "source boot_command.sh",
    // "wget http://{{ .HTTPIP }}:{{ .HTTPPort }}/generic.alpine316.vagrant.cfg<enter><wait>",
    // "sed -i -e \"/rc-service/d\" /sbin/setup-sshd<enter><wait>",
    // "source generic.alpine316.vagrant.cfg<enter><wait>",
    // "printf \"vagrant\\nvagrant\\ny\\n\" | sh /sbin/setup-alpine -f /root/generic.alpine316.vagrant.cfg && ",
    // "mount /dev/sda2 /mnt && ",
    // "sed -E -i '/#? ?PasswordAuthentication/d' /mnt/etc/ssh/sshd_config && ",
    // "sed -E -i '/#? ?PermitRootLogin/d' /mnt/etc/ssh/sshd_config && ",
    // "echo 'PasswordAuthentication yes' >> /mnt/etc/ssh/sshd_config && ",
    // "echo 'PermitRootLogin yes' >> /mnt/etc/ssh/sshd_config && ",
    // "chroot /mnt apk add openntpd && chroot /mnt rc-update add openntpd default && reboot<enter>"
  ]
  # boot_command script choked on last long command - repetative output (after reboot) showed something about changing the root password - over and over it scrolled insanely quickly - so something on reboot is behaving - or was it? what was sending key strokes after reboot?
  # TODO resume here with testing - run boot_command by hand and/or record system with vbox to find issue - and don't let packer cleanup anything until save recording outside ~/VirtualBox\ VM

  boot_keygroup_interval = "1s"
  boot_wait              = "120s" # slow to start with x86 emulation
  cpus                   = 2
  disk_size              = 131072 # 128 MB
  guest_additions_mode   = "upload"
  guest_additions_path   = "VBoxGuestAdditions.iso"
  guest_additions_sha256 = "9cf5413399f59cfa4ba9ed89a9295b1b2ef3b997cb526a100637b5c59a526872" # https://download.virtualbox.org/virtualbox/7.0.2/SHA256SUMS
  guest_additions_url    = "https://download.virtualbox.org/virtualbox/7.0.2/VBoxGuestAdditions_7.0.2.iso"
  guest_os_type          = "Linux" # 32-bit generic Linux # VBoxManage list ostypes
  hard_drive_interface   = "sata"
  headless               = true
  http_directory         = "http"
  iso_checksum           = "file:https://mirrors.edge.kernel.org/alpine/v3.16/releases/x86/alpine-virt-3.16.2-x86.iso.sha256"
  iso_url                = "https://mirrors.edge.kernel.org/alpine/v3.16/releases/x86/alpine-virt-3.16.2-x86.iso"
  memory                 = 2048 # 2 GB
  output_directory       = "output/alpine316-x86-virtualbox"
  shutdown_command       = "/sbin/poweroff"
  ssh_password           = "vagrant"
  ssh_port               = 22
  ssh_timeout            = "3600s"
  ssh_username           = "root"
  vboxmanage = [
    ["modifyvm", "{{ .Name }}", "--vram", "128"],
    ["modifyvm", "{{ .Name }}", "--graphicscontroller", "vmsvga"],
    ["modifyvm", "{{ .Name }}", "--cpus", 2],
    ["modifyvm", "{{ .Name }}", "--memory", 2048],
    ["modifyvm", "{{ .Name }}", "--audio", "none"],
    ["modifyvm", "{{ .Name }}", "--chipset", "ich9"],
    ["modifyvm", "{{ .Name }}", "--nested-paging", "off"],
    ["modifyvm", "{{ .Name }}", "--paravirt-provider", "none"],
    # todo - add recording flags to VM?
    # VBoxManage modifyvm <uuid | vmname> 
    #   [--recording= on | off ] 
    #   [--recording-screens= all | none | screen-ID[,screen-ID...] ] 
    #   [--recording-file=filename]
    #   [--recording-max-size=MB] 
    #   [--recording-max-time=msec] 
    #   [--recording-opts=key=value[,key=value...] ] 
    #   [--recording-video-fps=fps] 
    #   [--recording-video-rate=rate] 
    #   [--recording-video-res=widthheight]
    # also commands:
    #   VBoxManage controlvm <uuid | vmname> recording <on | off>
    #   VBoxManage controlvm <uuid | vmname> recording screens <all | none | screen-ID[,screen-ID...]>
    #   VBoxManage controlvm <uuid | vmname> recording filename <filename>
    #   VBoxManage controlvm <uuid | vmname> recording videores <widthxheight>
    #   VBoxManage controlvm <uuid | vmname> recording videorate <rate>
    #   VBoxManage controlvm <uuid | vmname> recording videofps <fps>
    #   VBoxManage controlvm <uuid | vmname> recording maxtime <sec>
    #   VBoxManage controlvm <uuid | vmname> recording maxfilesize <MB>
  ]
  # todo modify arch - disable paravirt, nested paging - use ICH9 chipset
  vm_name = "alpine316-x86-virtualbox"
}

build {
  sources = ["source.virtualbox-iso.alpine316-x86-virtualbox"]

  provisioner "shell" {
    execute_command   = "/bin/sh '{{ .Path }}'"
    expect_disconnect = "true"
    only              = ["alpine316-x86-virtualbox"]
    scripts = [
      "scripts/network.sh",
      "scripts/apk.sh"
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
      "scripts/hostname.sh",
      "scripts/lsb.sh",
      "scripts/floppy.sh",
      "scripts/vagrant.sh",
      "scripts/sshd.sh",
      "scripts/virtualbox.sh",
      "scripts/cache.sh"
    ]
    start_retry_timeout = "15m"
    timeout             = "2h0m0s"
  }

  post-processor "vagrant" {
    output               = "out/packer_{{.BuildName}}_{{.Provider}}.box"
    include              = ["info.json"]
    compression_level    = 9
    vagrantfile_template = "template-vagrantfile.rb"
  }
}
