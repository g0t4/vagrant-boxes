packer {
  required_plugins {
    parallels = {
      version = ">=1.0.3"
      source  = "github.com/hashicorp/parallels"
    }
  }
}

source "parallels-iso" "centos9s-arm" {

  iso_url      = "http://atl.mirrors.knownhost.com/centos/9-stream/BaseOS/aarch64/iso/CentOS-Stream-9-latest-aarch64-dvd1.iso"
  iso_checksum = "file:https://atl.mirrors.knownhost.com/centos/9-stream/BaseOS/aarch64/iso/CentOS-Stream-9-latest-aarch64-dvd1.iso.SHA256SUM"

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

}

build {
  sources = ["source.parallels-iso.centos9s-arm"]
  name    = "centos9s-arm"

  # note: provisioners run as root user (don't need sudo), see source's ("builder's") ssh communicator args
  provisioner "shell" {
    timeout = "10m"
    scripts = [
      "scripts/install.parallels.tools.sh",
      "scripts/updates.sh",
      "scripts/vagrant.sh",
      "scripts/tuning.sh",
      "scripts/cleanup.sh",
    ]
  }

  post-processor "vagrant" {
    output = "out/packer_{{.BuildName}}_{{.Provider}}.box" # default: "packer_{{.BuildName}}_{{.Provider}}.box"
  }
}
