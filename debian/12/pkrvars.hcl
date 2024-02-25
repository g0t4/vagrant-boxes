# NOTE 23.10 is still latest for server iso, only desktop has patch .1 release
# FYI need to update version in both spots for new release (releases/version and ubuntu-version), right now they are different b/c 23.10.1 is only for desktop:
iso_url      = "https://cdimage.ubuntu.com/releases/23.10.1/release/ubuntu-23.10-live-server-arm64.iso"
iso_checksum = "file:https://cdimage.ubuntu.com/releases/23.10.1/release/SHA256SUMS"

box_dir          = "12"
autoinstall_wait = "<wait4m>"

box_org  = "wesdemos"
box_name = "debian12" # not using -arm anymore now that arch is captured in box metadata

box_version      = "1.0.0"
box_version_desc = "initial debian 12"