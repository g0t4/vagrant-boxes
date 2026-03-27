iso_url = "https://cdimage.ubuntu.com/ubuntu-server/daily-live/current/resolute-live-server-arm64.iso"
# FYI find latest:
#   is daily-live IIUC while in development
#       => https://cdimage.ubuntu.com/ubuntu-server/daily-live/current/
#   later, s/b here:
#       => https://cdimage.ubuntu.com/releases/26.04/release/

iso_checksum = "file:https://cdimage.ubuntu.com/ubuntu-server/daily-live/current/SHA256SUMS"

box_dir          = "2604"
autoinstall_wait = "<wait4m>"

box_org  = "wesdemos"
box_name = "ubuntu2604-arm"

box_version      = "1.0.0"
box_version_desc = "Ubuntu Server 26.04 (Resolute Raccoon) Daily Live arm64"
