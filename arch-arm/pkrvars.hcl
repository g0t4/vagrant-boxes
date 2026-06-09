# Archboot is the only aarch64 ISO for Arch Linux (archlinux.org only ships x86_64)
# FYI find latest: https://release.archboot.com/aarch64/latest/iso/
#   TODO can I get a link that redirects to latest w/ build numbers so I don't have to update the URL here?
iso_url = "https://release.archboot.com/aarch64/latest/iso/archboot-2026.06.06-02.27-7.0.11-2-aarch64-ARCH-aarch64.iso"
# Archboot provides b2sum only (see https://release.archboot.com/aarch64/latest/b2sum.txt)
# Packer doesn't support b2 natively - compute sha256 manually or use "none" to skip verification
iso_checksum = "40dfb9a0615d26f6d01f74900a9e8e34ee10710a972db96058963ed40c503721"

box_org  = "wesdemos"
box_name = "arch-arm"

# Arch is rolling - use date-based version
box_version      = "2026.06.06"
box_version_desc = "Arch Linux aarch64 (rolling) - Apple Silicon / Parallels"
