# downloads: https://www.centos.org/centos-stream/
iso_url      = "http://mirror.facebook.net/centos-stream/9-stream/BaseOS/aarch64/iso/CentOS-Stream-9-latest-aarch64-dvd1.iso"
iso_checksum = "file:http://mirror.facebook.net/centos-stream/9-stream/BaseOS/aarch64/iso/CentOS-Stream-9-latest-aarch64-dvd1.iso.SHA256SUM"
# find mirrors: https://www.centos.org/download/mirrors/
#   or https://mirrors.centos.org/mirrorlist?path=/9-stream/BaseOS/aarch64/iso/CentOS-Stream-9-latest-aarch64-dvd1.iso
box_org  = "wesdemos"
box_name = "centos9s-arm"

box_version      = "1.1.0"
box_version_desc = "Build with latest (20240212.0) release"

# FYI to find version of latest release:
#  => http://atl.mirrors.knownhost.com/centos/9-stream/BaseOS/aarch64/iso
#  => look at dated release file (compare SHASUMS to verify the same)