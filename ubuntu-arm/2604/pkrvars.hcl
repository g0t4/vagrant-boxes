# TODO once daily-live moves onto next dev release... then use this for 26.04
# iso_url = "https://cdimage.ubuntu.com/releases/26.04.2/release/ubuntu-26.04.2-live-server-arm64.iso"
# find latest iso:
#   https://cdimage.ubuntu.com/releases/26.04.2/release/
# iso_checksum = "file:https://cdimage.ubuntu.com/releases/26.04.2/release/SHA256SUMS"

# dev release is 26.04 so use daily-live for now
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

box_version      = "1.0.0" # originally released march build under 1.0.0... and forgot to bump for may build... just FYI...
box_version_desc = "Ubuntu Server 26.04 (Resolute Raccoon) Daily Live arm64"
# box_version_desc = "ubuntu 26.04.2 arm64"
