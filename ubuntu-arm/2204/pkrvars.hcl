iso_url = "https://cdimage.ubuntu.com/releases/22.04.4/release/ubuntu-22.04.4-live-server-arm64.iso"
# https://cdimage.ubuntu.com/releases/22.04.4/release
#   look for ubuntu-22.04.4-live-server-arm64.iso
#     last 2024-02-20 00:52
# find newer patch releases: https://cdimage.ubuntu.com/releases/
iso_checksum     = "file:https://cdimage.ubuntu.com/releases/22.04.4/release/SHA256SUMS"
box_dir          = "2204"
autoinstall_wait = "<wait2m>"

box_org  = "wesdemos"
box_name = "ubuntu2204-arm"

box_version      = "1.1.5" # skipping 1.1.5 but not building yet
box_version_desc = "ubuntu 22.04.4 arm64"
