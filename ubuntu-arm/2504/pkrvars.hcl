iso_url = "https://cdimage.ubuntu.com/ubuntu-server/daily-live/current/plucky-live-server-arm64.iso"
# FYI find latest:
#   is daily-live IIUC while in development
#       => https://cdimage.ubuntu.com/ubuntu-server/daily-live/current/
#   later, s/b here:
#       => https://cdimage.ubuntu.com/releases/25.04/release/

iso_checksum = "file:https://cdimage.ubuntu.com/ubuntu-server/daily-live/current/SHA256SUMS"

box_dir          = "2504"
autoinstall_wait = "<wait4m>"

box_org  = "wesdemos"
box_name = "ubuntu2504-arm"

box_version      = "1.1.7"
box_version_desc = "Ubuntu Server 25.04 (Plucky Puffin) Daily Live arm64"
