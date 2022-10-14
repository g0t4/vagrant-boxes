packer {
  required_plugins {
    parallels = {
      version = ">=1.0.3"
      source  = "github.com/hashicorp/parallels"
    }
  }
}

variable "autoinstall_wait" {
  type    = string
  default = "<wait2m>"
}
variable "ubuntu_slug" {
  type    = string
  default = "ubuntu2204-arm"
}
variable "ubuntu_iso_url" {
  type    = string
  default = "https://cdimage.ubuntu.com/releases/22.04.1/release/ubuntu-22.04.1-live-server-arm64.iso"
}
variable "ubuntu_iso_checksum" {
  type    = string
  default = "file:https://cdimage.ubuntu.com/releases/22.04.1/release/SHA256SUMS"
}

source "parallels-iso" "ubuntu-arm" {

  iso_url      = var.ubuntu_iso_url
  iso_checksum = var.ubuntu_iso_checksum

  # packer's ssh communicator config => packer (builders, provisioners, etc) connect as:
  # https://www.packer.io/docs/communicators/ssh
  ssh_username           = "vagrant"
  ssh_password           = "password"
  ssh_timeout            = "20m"
  ssh_handshake_attempts = 20 # see notes on troubleshooting for details about SSH quirks with ubuntu's autoinstall SSH server

  parallels_tools_flavor = "lin-arm"
  shutdown_command       = "echo 'password' | sudo -S shutdown -P now"
  guest_os_type          = "ubuntu"

  cpus   = 4
  memory = 4096

  http_directory = "http" # serve autoinstall files
  boot_command = [
    # ubuntu22.04 uses GRUB v2 boot loader
    # open grub's "BASH-like" (c)ommand line:
    "<esc><esc>c",
    # commands: https://www.gnu.org/software/grub/manual/grub/html_node/Command_002dline-and-menu-entry-commands.html

    # load kernel w/ autoinstall files for unattended install
    # - `autoinstall` kernel CLI arg required, else prompt to format disk
    "linux /casper/vmlinuz \"ds=nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/\" --- autoinstall",
    "<enter>",
    "initrd /casper/initrd",
    "<enter>",
    "boot",
    "<enter><wait>",
    "${autoinstall_wait}",
  ]

}

build {
  sources = ["source.parallels-iso.ubuntu-arm"]
  name    = "${var.ubuntu_slug}"

  provisioner "shell" {
    execute_command = "echo 'password' | sudo -S sh -c '{{ .Vars }} {{ .Path }}'"
    script          = "scripts/sudoers.sh"
  }

  # note: provisioners run as vagrant user (thus need sudo or similiar), see source's ("builder's") ssh communicator args
  provisioner "shell" {
    scripts = [
      "scripts/install.parallels.tools.sh",
      "scripts/updates.sh",
      "scripts/cleanup.sh",
    ]
  }

  post-processor "vagrant" {
    output = "out/packer_{{.BuildName}}_{{.Provider}}.box" # default: "packer_{{.BuildName}}_{{.Provider}}.box"
  }

}

