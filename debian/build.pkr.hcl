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

source "parallels-iso" "debian-arm" {

  iso_url      = var.iso_url
  iso_checksum = var.iso_checksum

  # packer's ssh communicator config => packer (builders, provisioners, etc) connect as:
  # https://www.packer.io/docs/communicators/ssh
  ssh_username           = "vagrant"
  ssh_password           = "password"
  ssh_timeout            = "20m"
  ssh_handshake_attempts = 20

  parallels_tools_flavor = "lin-arm"
  shutdown_command       = "systemctl poweroff" # no shutdown command avail, TODO what does packer do by default if I don't specify this?
  # todo does this work? or use /sbin/halt -p or similiar? I forgot to check too if poweroff is avail as root? shutdown command wasn't avail as root alone... maybe manual path... todo
  guest_os_type          = "debian"
  host_interfaces        = ["en0", "en1", "en2", "en3", "en4", "en5", "en6", "en7", "en8", "en9", "en10", "en11", "en12", "en13", "en14", "en15", "en16", "en17", "en18", "en19", "en20", "ppp0", "ppp1", "ppp2"]
  # default list of host_interfaces checked stops at en9: https://github.com/Parallels/packer-plugin-parallels/blob/master/builder/parallels/iso/builder.go#L147-L151

  cpus   = 4
  memory = 4096

  http_directory = "http" # serve autoinstall files
  # TODO modify boot command? how about break it up a bit like ubuntu and document the steps taken so I can troubleshoot issues:
  #    ALSO, add in autoinstall_wait var for timing?
  boot_command = [
    # navigate install menus to get to custom boot command and put cursor right after:
    #      linux /install.a64/vmlinuz [CURSOR]
    "<wait><up>e<wait><down><down><down><right><right><right><right><right><right><right><right><right><right><right><right><right><right><right><right><right><right><right><right><right><right><right><right><right><right><right><right><right><right><right><right><right><right><wait>",
    # add to end of boot command:
    "install <wait> preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg <wait>debian-installer=en_US.UTF-8 <wait>auto <wait>locale=en_US.UTF-8 <wait>kbd-chooser/method=us <wait>keyboard-configuration/xkb-keymap=us <wait>netcfg/get_hostname={{ .Name }} <wait>netcfg/get_domain=vagrantup.com <wait>fb=false <wait>debconf/frontend=noninteractive <wait>console-setup/ask_detect=false <wait>console-keymaps-at/keymap=us <wait>grub-installer/bootdev=/dev/sda <wait>",
    # submit:
    "<f10><wait>",
    # TODO domain=vagrantup.com ? CHANGE?
  ]

  vm_name          = "build-${var.box_name}"
  output_directory = "build-${var.box_name}"
}

build {
  sources = ["source.parallels-iso.debian-arm"]
  name    = "${var.box_name}"

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
      # PRN networking
      # PRN systemd_ssh_shutdown.sh
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

