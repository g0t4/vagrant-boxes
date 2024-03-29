# https://www.debian.org/releases/bookworm/debian-installer/
#   https://cdimage.debian.org/debian-cd/12.5.0/
#   current:
#     https://cdimage.debian.org/cdimage/release/
#       i.e.:  https://cdimage.debian.org/cdimage/release/12.5.0/arm64/iso-cd/debian-12.5.0-arm64-netinst.iso
#         FYI also: https://cdimage.debian.org/cdimage/release/current/arm64/iso-cd/debian-12.5.0-arm64-netinst.iso
#   archive (not current):
#     https://cdimage.debian.org/cdimage/archive/
#       i.e.:  https://cdimage.debian.org/cdimage/archive/11.9.0/arm64/iso-cd/debian-11.9.0-arm64-netinst.iso
#   notes:
#   - link changes once not current
#     - most of the time I intend to build current only so this shouldn't be a huge deal
#   - IIOC arm64 only has minimal netinst cd
#     - and, amd64 only has full netinst cd
#
iso_url      = "https://cdimage.debian.org/cdimage/release/12.5.0/arm64/iso-cd/debian-12.5.0-arm64-netinst.iso"
# FYI last iso released: 2024-02-10 14:48	526M
iso_checksum = "file:https://cdimage.debian.org/cdimage/release/12.5.0/arm64/iso-cd/SHA256SUMS"
#
# TODO try iso-dvd
#   was wondering if DVD would work and then I stumbled on bento using it so I wanna try it at some point:
#   iso_url = "https://cdimage.debian.org/cdimage/release/12.5.0/arm64/iso-dvd/debian-12.5.0-arm64-DVD-1.iso"
#   iso_checksum = "file:https://cdimage.debian.org/cdimage/release/12.5.0/arm64/iso-dvd/SHA256SUMS"

box_dir          = "12"
autoinstall_wait = "<wait4m>" # TODO do I need to add this to bootcmd? OR NUKE IT?

box_org  = "wesdemos"
box_name = "debian12-arm" # not using -arm anymore now that arch is captured in box metadata

box_version      = "1.1.4"
box_version_desc = "debian 12 arm64"