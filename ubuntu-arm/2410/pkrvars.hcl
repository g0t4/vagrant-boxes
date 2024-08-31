iso_url = "https://cdimage.ubuntu.com/ubuntu-server/daily-live/current/oracular-live-server-arm64.iso"
# FYI find latest:
#   24.10 is daily-live IIUC while in development
#       => https://cdimage.ubuntu.com/ubuntu-server/daily-live/current/
#   later, s/b here:
#       => https://cdimage.ubuntu.com/releases/24.10/release/

iso_checksum = "file:https://cdimage.ubuntu.com/ubuntu-server/daily-live/current/SHA256SUMS"

box_dir          = "2410"
autoinstall_wait = "<wait4m>"

box_org  = "wesdemos"
box_name = "ubuntu2410-arm"

box_version      = "1.1.6"
box_version_desc = "Ubuntu Server 24.10 (Oracular Oriole) Daily Live arm64"
