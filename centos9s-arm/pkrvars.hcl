# downloads: https://www.centos.org/centos-stream/
iso_url      = "http://mirror.facebook.net/centos-stream/9-stream/BaseOS/aarch64/iso/CentOS-Stream-9-latest-aarch64-dvd1.iso"
iso_checksum = "file:http://mirror.facebook.net/centos-stream/9-stream/BaseOS/aarch64/iso/CentOS-Stream-9-latest-aarch64-dvd1.iso.SHA256SUM"
# http://mirror.facebook.net/centos-stream/9-stream/BaseOS/aarch64/iso/
#   look for: CentOS-Stream-9-latest-aarch64-dvd1.iso
#     last iso released: 20240318.0 @ 2024-03-17 21:10
# find mirrors: https://www.centos.org/download/mirrors/
#   or https://mirrors.centos.org/mirrorlist?path=/9-stream/BaseOS/aarch64/iso/CentOS-Stream-9-latest-aarch64-dvd1.iso
box_org  = "wesdemos"
box_name = "centos9s-arm"

box_version      = "1.1.5"
box_version_desc = "Build with latest iso (20240318.0) release"

# FYI to find version of latest release:
#  => http://atl.mirrors.knownhost.com/centos/9-stream/BaseOS/aarch64/iso
#  => look at dated release file (compare SHASUMS to verify the same)
