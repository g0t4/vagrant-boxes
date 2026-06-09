# Ubuntu 26.10 "Mantic Minotaur" - using snapshot-1 (early test build)
# FYI find latest:
#   => https://cdimage.ubuntu.com/releases/26.10/snapshot-1/
#   later, s/b here when daily-live starts:
#       => https://cdimage.ubuntu.com/ubuntu-server/daily-live/current/

iso_url      = "https://cdimage.ubuntu.com/releases/26.10/snapshot-1/ubuntu-26.10-snapshot1-live-server-arm64.iso"
iso_checksum = "80c03c7354389d44c931df0ddcdbb0f1ce4d9d74f72b905ffa4ccd1e2de0092b"

box_dir          = "2610"
autoinstall_wait = "<wait4m>"

box_org  = "wesdemos"
box_name = "ubuntu2610-arm"

box_version      = "1.0.0"
box_version_desc = "Ubuntu Server 26.10 (Mantic Minotaur) Snapshot 1 arm64"
