packer {
  required_plugins {
    parallels = {
      version = ">=1.0.3"
      source  = "github.com/hashicorp/parallels"
    }
  }
}


variable "iso_url" { type = string }
variable "iso_checksum" { type = string }

variable "box_org" { type = string }
variable "box_name" { type = string }
local "box_tag" { expression = "${var.box_org}/${var.box_name}" }

variable "box_version" { type = string }
variable "box_version_desc" { type = string }

source "parallels-iso" "centos9s-arm" {

  iso_url      = var.iso_url
  iso_checksum = var.iso_checksum

  # use root for provisioning only (last provision script disables root login)
  ssh_username = "root"
  ssh_password = "vagrant"
  ssh_timeout  = "20m"

  parallels_tools_flavor = "lin-arm"
  shutdown_command       = "echo 'vagrant' | sudo -S shutdown -P now"
  guest_os_type          = "centos" # prlctl create x --distribution list

  cpus   = 4
  memory = 4096

  # force packer to use same port each time, breaks parallelity so don't leave on:
  # http_port_min     = 8888
  # http_port_max     = 8888
  # http_bind_address = "192.168.X.X"

  http_directory = "http" # serve kickstart files for unattended install
  boot_command = [
    # select top menu entry (middle is default), e = edit it
    "<up>e",

    # takes cursor to end of line to edit (linux load command)
    "<down><down><down><left>",
    # append kernel CLI args
    " net.ifnames=0 inst.text inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/install.ks vga=792 ",

    # start install w/ ctrl+x
    "<leftCtrlOn>x<leftCtrlOff>",
    "<wait>"
  ]

  prlctl = [
    ["set", "{{.Name}}", "--faster-vm", "on"],
    ["set", "{{.Name}}", "--adaptive-hypervisor", "on"], # https://kb.parallels.com/en/122828
    ["set", "{{.Name}}", "--3d-accelerate", "off"],
  ]

  vm_name          = "build-${var.box_name}"
  output_directory = "build-${var.box_name}"
}

build {
  sources = ["source.parallels-iso.centos9s-arm"]
  name    = "${var.box_name}"

  # note: provisioners run as root user (don't need sudo), see source's ("builder's") ssh communicator args
  provisioner "shell" {
    timeout = "10m"
    scripts = [
      "scripts/parallels.tools.sh",
      "scripts/apt.sh",
      "scripts/vagrant-ssh.sh",
      "scripts/tuning.sh",
      "scripts/cleanup.sh",
    ]
  }

  post-processors {
    post-processor "vagrant" {
      output = "out/packer_${var.box_name}_{{.Provider}}.box"
      # box files: https://developer.hashicorp.com/vagrant/docs/boxes/format
      include           = ["info.json"]
      compression_level = 9 # default = 6
    }

    post-processor "vagrant-cloud" {
      box_tag             = "${local.box_tag}"
      version             = "${var.box_version}"
      version_description = "${var.box_version_desc}"
    }
  }
}
