# NOTE 23.10 is still latest for server iso, only desktop has patch .1 release
# FYI need to update version in both spots for new release (releases/version and ubuntu-version), right now they are different b/c 23.10.1 is only for desktop:
iso_url      = "https://cdimage.ubuntu.com/releases/23.10.1/release/ubuntu-23.10-live-server-arm64.iso"
iso_checksum = "file:https://cdimage.ubuntu.com/releases/23.10.1/release/SHA256SUMS"

box_dir          = "2310"
autoinstall_wait = "<wait4m>"

box_org  = "wesdemos"
box_name = "ubuntu2310-arm"

box_version      = "1.1.3"
box_version_desc = "ubuntu 23.10 arm64"