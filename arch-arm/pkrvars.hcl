# Archboot is the only aarch64 ISO for Arch Linux (archlinux.org only ships x86_64)
# FYI find latest: https://release.archboot.com/aarch64/latest/iso/
iso_url = "https://release.archboot.com/aarch64/latest/iso/archboot-2026.03.27-02.26-6.19.10-1-aarch64-ARCH-aarch64.iso"
# Archboot provides b2sum only (see https://release.archboot.com/aarch64/latest/b2sum.txt)
# Packer doesn't support b2 natively - compute sha256 manually or use "none" to skip verification
iso_checksum = "none"

box_org  = "wesdemos"
box_name = "arch-arm"

# Arch is rolling - use date-based version
box_version      = "2026.03.30"
box_version_desc = "Arch Linux aarch64 (rolling) - Apple Silicon / Parallels"
