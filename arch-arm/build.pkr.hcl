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

  # TODO: boot_command needs verification by booting archboot interactively first
  # Archboot aarch64 boots with GRUB, then starts its own setup TUI on TTY1.
  # Goals: exit the TUI, get a root shell, run install.sh via curl.
  #
  # Approach A (below): modify GRUB entry to boot into rescue.target (skip TUI)
  #   - press 'e' at GRUB menu to edit default entry
  #   - navigate to 'linux ...' kernel line and append systemd.unit=rescue.target
  #   - ctrl+x to boot, wait, get rescue shell, then start networking manually
  #
  # Approach B (commented out): let archboot TUI start, exit to shell
  #   - wait longer for TUI to appear, navigate menu to "Shell" option
  #   - archboot menus often have a numbered or arrow-key-navigated "Exit/Shell" choice
  boot_command = [
    # Wait for GRUB menu to appear
    "<wait10>",

    # Edit the default GRUB entry to skip archboot's setup TUI
    "e",
    "<wait2>",

    # Navigate to the 'linux' kernel line (line count varies - adjust <down> count as needed)
    # In archboot GRUB edit, the linux line is typically 8-10 lines down
    "<down><down><down><down><down><down><down><down>",
    "<end>",
    # Skip archboot's interactive setup service, boot to rescue shell instead
    " systemd.unit=rescue.target",

    # Boot with ctrl+x
    "<leftCtrlOn>x<leftCtrlOff>",

    # Wait for rescue shell (~2-3 min for archboot kernel + systemd to start)
    "<wait3m>",

    # Rescue shell auto-logins as root (or press enter if prompted)
    "<enter><wait5>",

    # Start network (rescue.target doesn't start networking)
    "systemctl start systemd-networkd.service<enter><wait10>",
    "systemctl start systemd-resolved.service<enter><wait5>",

    # Download and run installation script
    # install.sh partitions, formats, pacstraps, configures, and reboots
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
      "scripts/parallels.tools.sh",
      "scripts/pacman.sh",
      "scripts/networking.sh",
      "scripts/vagrant-ssh.sh",
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
