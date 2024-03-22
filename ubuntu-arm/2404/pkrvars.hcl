iso_url      = "https://cdimage.ubuntu.com/ubuntu-server/daily-live/current/noble-live-server-arm64.iso"
# find latest iso:
#   https://cdimage.ubuntu.com/ubuntu-server/daily-live/current
#   find noble-live-server-arm64.iso
#     last 2024-03-21 08:17 # pending rebuild
iso_checksum = "file:https://cdimage.ubuntu.com/ubuntu-server/daily-live/current/SHA256SUMS"

box_dir          = "2404"
autoinstall_wait = "<wait4m>"

box_org  = "wesdemos"
box_name = "ubuntu2404-arm"

box_version      = "1.1.5"
box_version_desc = "ubuntu 24.04 daily-live arm64 - 2024-03-21 08:17 iso"