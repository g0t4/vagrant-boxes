packer {
  required_plugins {
    parallels = {
      version = ">=1.1.0"
      source  = "github.com/hashicorp/parallels"
    }
    vagrant = {
      source  = "github.com/hashicorp/vagrant"
      version = ">=1.1.4"
    }
  }
}

# vagrant registry:
variable "client_id" {
  type      = string
  sensitive = true
}
variable "client_secret" {
  type      = string
  sensitive = true
}

variable "iso_url" { type = string }
variable "iso_checksum" { type = string }

variable "box_org" { type = string }
variable "box_name" { type = string }
local "box_tag" { expression = "${var.box_org}/${var.box_name}" }

variable "box_version" { type = string }
variable "box_version_desc" { type = string }

source "parallels-iso" "arch-arm" {

  iso_url      = var.iso_url
  iso_checksum = var.iso_checksum

  ssh_username           = "vagrant"
  ssh_password           = "vagrant"
  ssh_timeout            = "30m"
  ssh_handshake_attempts = 20

  parallels_tools_flavor = "lin-arm"
  shutdown_command       = "echo 'vagrant' | sudo -S shutdown -P now"
  guest_os_type          = "linux" # prlctl create x --distribution list
  host_interfaces        = ["en0", "en1", "en2", "en3", "en4", "en5", "en6", "en7", "en8", "en9", "en10", "en11", "en12", "en13", "en14", "en15", "en16", "en17", "en18", "en19", "en20", "ppp0", "ppp1", "ppp2"]
  # default list of host_interfaces checked stops at en9: https://github.com/Parallels/packer-plugin-parallels/blob/master/builder/parallels/iso/builder.go#L147-L151

  cpus      = 4
  memory    = 8192 # archboot needs at least 750MB, more is safer; 4096 may work too
  disk_size = 20480

  http_directory = "http" # serves install.sh

  # Archboot boot sequence (for reference when tuning boot_command):
  #
  # 1. Parallels VM starts, GRUB menu appears
  #    - GRUB has a countdown timer (auto-boots into archboot after timeout)
  #    - No interaction needed
  #
  # 2. Archboot loads
  #    - Virtual terminal appears ~2 seconds after GRUB boots
  #    - Welcome screen displays:
  #        "Welcome to Archboot - Arch Linux AARCH64"
  #        ...
  #        "Hit ENTER for login routine or CTRL-C for bash prompt."
  #    - Networking (DHCP) is already configured at this point
  #    - setup = interactive TUI installer (NOT auto-started, must run manually)
  #
  # 3. Ctrl+C → immediate root bash prompt [root@archboot /]#
  #    - No password needed
  #    - curl, fdisk, pacstrap, arch-chroot all available
  #
  # Total time from VM start to ready prompt: GRUB timeout + ~2s
  # <wait20s> has been sufficient in testing
  boot_command = [
    # Wait for GRUB to auto-boot + archboot to start + welcome screen to appear
    "<wait20s>",

    # Get a bash prompt directly (skip the login routine)
    "<leftCtrlOn>c<leftCtrlOff>",
    "<wait2>",

    # Download and run installation script from packer's HTTP server
    # install.sh partitions, formats, pacstraps, configures grub, and reboots
    "curl http://{{ .HTTPIP }}:{{ .HTTPPort }}/install.sh | bash<enter>",

    # Packer waits for SSH to come up on the newly installed system (ssh_timeout = 30m)
  ]

  vm_name          = "build-${var.box_name}"
  output_directory = "build-${var.box_name}"
}

build {
  sources = ["source.parallels-iso.arch-arm"]
  name    = "${var.box_name}"

  # vagrant user has passwordless sudo (set up in install.sh)
  provisioner "shell" {
    scripts = [
      "scripts/pacman.sh",
      "scripts/networking.sh",
      "scripts/vagrant-ssh.sh",
      "scripts/parallels.tools.sh", # TODO: parallels tools fails on arch, troubleshoot separately
      "scripts/cleanup.sh",
    ]
  }

  post-processors {
    # note this is a chain of post-processors, NOT separate post-processors

    # https://www.packer.io/plugins/post-processors/vagrant/vagrant
    post-processor "vagrant" {
      output            = "out/packer_${var.box_name}_{{.Provider}}.box"
      include           = ["info.json"]
      compression_level = 9 # default = 6
    }

    # https://developer.hashicorp.com/packer/integrations/hashicorp/vagrant/latest/components/post-processor/vagrant-registry
    post-processor "vagrant-registry" {
      client_id           = "${var.client_id}"
      client_secret       = "${var.client_secret}"
      box_tag             = "${local.box_tag}"
      version             = "${var.box_version}"
      version_description = "${var.box_version_desc}"
    }
  }
}
