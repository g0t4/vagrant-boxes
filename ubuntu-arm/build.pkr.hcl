packer {
  required_plugins {
    parallels = {
      version = ">=1.0.3"
      source  = "github.com/hashicorp/parallels"
    }
    vagrant = {
      source  = "github.com/hashicorp/vagrant"
      version = "~> 1"
    }
  }
}

variable "iso_url" { type = string }
variable "iso_checksum" { type = string }

variable "box_dir" { type = string }
variable "autoinstall_wait" { type = string }

variable "box_org" { type = string }
variable "box_name" { type = string }
local "box_tag" { expression = "${var.box_org}/${var.box_name}" }

variable "box_version" { type = string }
variable "box_version_desc" { type = string }

source "parallels-iso" "ubuntu-arm" {

  iso_url      = var.iso_url
  iso_checksum = var.iso_checksum

  # packer's ssh communicator config => packer (builders, provisioners, etc) connect as:
  # https://www.packer.io/docs/communicators/ssh
  ssh_username           = "vagrant"
  ssh_password           = "vagrant"
  ssh_timeout            = "20m"
  ssh_handshake_attempts = 20 # see notes on troubleshooting for details about SSH quirks with ubuntu's autoinstall SSH server

  parallels_tools_flavor = "lin-arm"
  shutdown_command       = "echo 'vagrant' | sudo -S shutdown -P now"
  guest_os_type          = "ubuntu"
  host_interfaces        = ["en0", "en1", "en2", "en3", "en4", "en5", "en6", "en7", "en8", "en9", "en10", "en11", "en12", "en13", "en14", "en15", "en16", "en17", "en18", "en19", "en20", "ppp0", "ppp1", "ppp2"]
  # default list of host_interfaces checked stops at en9: https://github.com/Parallels/packer-plugin-parallels/blob/master/builder/parallels/iso/builder.go#L147-L151

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
    "${var.autoinstall_wait}",
  ]

  vm_name          = "build-${var.box_name}"
  output_directory = "build-${var.box_name}"
}

build {
  sources = ["source.parallels-iso.ubuntu-arm"]
  name    = "${var.box_name}"

  provisioner "shell" {
    execute_command = "echo 'vagrant' | sudo -S sh -c '{{ .Vars }} {{ .Path }}'"
    script          = "scripts/sudoers.sh"
  }

  # note: provisioners run as vagrant user (thus need sudo or similiar), see source's ("builder's") ssh communicator args
  provisioner "shell" {
    scripts = [
      "scripts/parallels.tools.sh",
      "scripts/apt.sh",
      "scripts/networking.sh",
      "scripts/cleanup.sh",
    ]
  }

  post-processors {
    # note this is a chain of post-processors, NOT separte post-processors

    # https://www.packer.io/plugins/post-processors/vagrant/vagrant
    post-processor "vagrant" {
      output            = "out/packer_${var.box_name}_{{.Provider}}.box"
      include           = ["${var.box_dir}/info.json"]
      compression_level = 9 # default = 6
    }

    # https://www.packer.io/plugins/post-processors/vagrant/vagrant-cloud
    post-processor "vagrant-cloud" {
      box_tag = "${local.box_tag}"
      version = "${var.box_version}"
      # keep_input_artifact = true # default = true
      # no_release = "true" # is this a string or bool or otherwise? docs say string but then say default = false...
      version_description = "${var.box_version_desc}"
    }

  }

}

