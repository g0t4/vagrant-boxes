# Qwen Reference: Vagrant Box Updates & Creation

## Quick Reference

### 1. Check for New ISOs

**Ubuntu Official Releases:**
```bash
curl -sL https://cdimage.ubuntu.com/releases/<VERSION>/release/ | grep -i "live-server-arm64"
curl -sL https://cdimage.ubuntu.com/releases/<VERSION>/release/SHA256SUMS | grep arm64
```

**Ubuntu Daily-Live (dev releases):**
```bash
curl -sL https://cdimage.ubuntu.com/ubuntu-server/daily-live/current/ | grep -i "live-server-arm64"
```

**Ubuntu Snapshots (early test builds):**
```bash
curl -sL https://cdimage.ubuntu.com/releases/<VERSION>/snapshot-1/ | grep -i "live-server-arm64"
```

**Arch Linux (Archboot for ARM):**
```bash
curl -sL https://release.archboot.com/aarch64/latest/iso/ | grep -i "aarch64"
curl -sL https://release.archboot.com/aarch64/latest/b2sum.txt | grep -i "aarch64-ARCH-aarch64.iso"
```

**Debian:**
```bash
curl -sL https://cdimage.debian.org/cdimage/release/ | grep -oE 'debian-[0-9]+\.[0-9]+' | sort -V | tail -1
curl -sL "https://cdimage.debian.org/cdimage/release/<VER>/arm64/iso-cd/" | grep -oE 'href="[^"]+\.iso"' | head -1
```

### 2. Compute SHA256

**Ubuntu/Debian:** Get from `SHA256SUMS` file directly.

**Archboot (BLAKE2b → SHA256):** Packer doesn't support BLAKE2b natively, so download and compute:
```bash
cd /tmp
curl -L -o archboot.iso https://release.archboot.com/aarch64/latest/iso/<ISO_NAME>
shasum -a 256 archboot.iso
rm archboot.iso
```

### 3. Packer Configuration Changes (vagrant-cloud → vagrant-registry)

**IMPORTANT:** All distros now use the newer `vagrant-registry` post-processor instead of the older `vagrant-cloud`.

**Before (old):**
```hcl
post-processor "vagrant-cloud" {
  box_tag             = "${var.box_tag}"
  version             = "${var.box_version}"
}
# Requires VAGRANT_CLOUD_TOKEN env var
```

**After (new):**
```hcl
variable "client_id" { type = string; sensitive = true }
variable "client_secret" { type = string; sensitive = true }

post-processor "vagrant-registry" {
  client_id           = "${var.client_id}"
  client_secret       = "${var.client_secret}"
  box_tag             = "${local.box_tag}"
  version             = "${var.box_version}"
}
```

This allows `packer validate` to run with dummy credentials instead of requiring real tokens.

### 4. Update Existing Box Version (e.g., Ubuntu 26.04 daily-live → official)

**File:** `<dir>/pkrvars.hcl`

```hcl
# Keep historical comments for reference!
# TODO once daily-live moves onto next dev release... then use this for 26.04
# iso_url = "https://cdimage.ubuntu.com/releases/26.04.2/release/ubuntu-26.04.2-live-server-arm64.iso"

# ACTIVE: Update to new ISO
iso_url = "https://cdimage.ubuntu.com/releases/26.04/release/ubuntu-26.04-live-server-arm64.iso"
iso_checksum = "<hardcoded-sha256>"  # Was "none" or "file:..."

# Bump version when ISO changes
box_version = "<new-version>"
```

**Key decisions:**
- Hardcode the checksum (don't use `file:` remote lookup) so you're forced to update both checksum AND version when ISO changes
- Keep old comments in place for historical context
- Version bump strategy:
  - Official release from daily-live: `1.1.9` → `1.2.0` (minor bump)
  - New snapshot: `1.0.0` (first release of that snapshot)

### 5. Create New Box Version Directory

**Directory structure:** `<version>/pkrvars.hcl`, `<version>/Vagrantfile`, `<version>/info.json`

**Step 1: Create directory and files**
```bash
mkdir -p ubuntu-arm/<VERSION>
```

**Step 2: `pkrvars.hcl`**
```hcl
# Ubuntu <VERSION> "<CODENAME>" - using snapshot-1 (early test build)
# FYI find latest:
#   => https://cdimage.ubuntu.com/releases/<VERSION>/snapshot-1/
#   later, s/b here when daily-live starts:
#       => https://cdimage.ubuntu.com/ubuntu-server/daily-live/current/

iso_url = "https://cdimage.ubuntu.com/releases/<VERSION>/snapshot-1/<ISO_FILE>"
iso_checksum = "<hardcoded-sha256>"

box_dir          = "<VERSION>"
autoinstall_wait = "<wait4m>"

box_org  = "wesdemos"
box_name = "ubuntu<VERSION>-arm"

box_version      = "1.0.0"
box_version_desc = "Ubuntu Server <VERSION> (<CODENAME>) Snapshot 1 arm64"
```

**Step 3: `Vagrantfile`** (copy from existing version)
```ruby
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "test-ubuntu<VERSION>-arm"
  config.vm.box_url = "file://../out/packer_ubuntu<VERSION>-arm_parallels.box"
end
```

**Step 4: `info.json`** (copy from existing version, update description)
```json
{
  "author": "Wes Higbee",
  "website": "https://github.com/g0t4/vagrant-boxes",
  "repository": "https://github.com/g0t4/vagrant-boxes",
  "description": "Ubuntu <VERSION> arm (aarch64) - compatible with Apple Silicon"
}
```

**Step 5: Create build script `build.<VERSION>.fish`** (copy from existing version)
```fish
#!/usr/bin/env fish -i

vagrant_cloud_token

# temp workaround for parallels virtualization sdk
export PYTHONPATH=/Library/Frameworks/ParallelsVirtualizationSDK.framework/Versions/Current/Libraries/Python/3.7

packer build -on-error ask -timestamp-ui \
  -var-file="<VERSION>/pkrvars.hcl" \
  -var="client_id=$VAGRANT_HCP_CLIENT_ID" \
  -var="client_secret=$VAGRANT_HCP_CLIENT_SECRET" \
  .
```

**Step 6: Update `validate-fmt.fish`** to include new version
```fish
# Add to validation list
validate "<VERSION>/pkrvars.hcl"

# Add to formatting list
packer fmt <VERSION>/pkrvars.hcl
```

### 6. Validate and Format

**Ubuntu (uses validate-fmt.fish):**
```bash
cd ubuntu-arm
fish validate-fmt.fish
```

**Other distros (uses validate-fmt.sh with dummy creds):**
```bash
cd <distro-dir>
fish validate-fmt.sh
```

This runs:
- `packer validate -var-file="<dir>/pkrvars.hcl" -var="client_id=dummy" -var="client_secret=dummy"`
- `packer fmt <dir>/pkrvars.hcl` to auto-format HCL files

### 7. Run the Build

**With credentials (full build + Vagrant Cloud upload):**
```bash
cd <distro-dir>
./build.<VERSION>.fish
# or: fish build.<VERSION>.fish
```

**Without credentials (local box only, for testing):**
```bash
cd <distro-dir>
packer build -var-file="<VERSION>/pkrvars.hcl" \
  -var="client_id=dummy" \
  -var="client_secret=dummy" .
```

**Expected output:**
- Build takes ~7-10 minutes
- Local box created at `out/packer_<box_name>_parallels.box`
- Vagrant Cloud upload to `wesdemos/<box_name>` (version <box_version>)

### 8. Common Issues & Fixes

**Vagrant Cloud auth fails:**
```
Error: failed to get new token: oauth2: "unauthorized" "Authentication failed."
```
→ Run with real credentials via `build.<VERSION>.fish` (uses `vagrant_cloud_token` function)

**Permission denied on build script:**
```bash
chmod +x build.<VERSION>.fish
```

**Packer validate fails with missing variables:**
```bash
# Test without Vagrant Cloud registry
packer validate -var-file="<VERSION>/pkrvars.hcl" \
  -var="client_id=dummy" \
  -var="client_secret=dummy" .
```

### 9. Commit Strategy

```bash
cd /Users/wes/repos/github/g0t4/vagrant-boxes
git add <distro>/<VERSION>/ <distro>/build.<VERSION>.fish <distro>/validate-fmt.sh
git commit -m "<distro>: add <OS> <VERSION> (<CODENAME>) build"
```

## Distro-Specific Notes

### Ubuntu ARM (`ubuntu-arm/`)
- Uses `vagrant-registry` post-processor with inline dummy creds for validation
- Build scripts: `build.2204.fish`, `build.2404.fish`, `build.2510.fish`, `build.2604.fish`, `build.2610.fish`
- Validation script: `validate-fmt.fish`

### Arch ARM (`arch-arm/`)
- Uses Archboot (only aarch64 ISO available)
- BLAKE2b checksums must be converted to SHA256 manually
- Build script: `build.fish`
- Validation script: `validate-fmt.sh`

### Debian ARM (`debian-arm/`)
- Currently supports only Debian 13 ("Trixie")
- Uses `vagrant-registry` post-processor with inline dummy creds for validation
- Build script: `build.13.fish`
- Validation script: `validate-fmt.sh`

### Alpine x86 (`alpine-x86/`)
- Supports emulated and native builds
- Uses `vagrant-registry` post-processor with inline dummy creds for validation
- Build scripts: `build.emulated.fish`, `build.native.fish`
- Validation script: `validate-fmt.sh`

### CentOS 9 Stream (`centos9s-arm/`)
- Uses `vagrant-registry` post-processor with inline dummy creds for validation
- Build script: `build.fish`
- Validation script: `validate-fmt.sh`

## Ubuntu Release Cycle Reference

| Phase | URL Pattern | Availability |
|-------|-------------|--------------|
| Snapshot (early test) | `releases/<VER>/snapshot-1/` | ~2 months before release |
| Daily-Live (dev) | `ubuntu-server/daily-live/current/` | ~1 month before release |
| Official Release | `releases/<VER>/release/` | On release day (April/October) |

## Key URLs

- **Ubuntu ISOs:** https://cdimage.ubuntu.com/
- **Archboot ARM:** https://release.archboot.com/aarch64/latest/iso/
- **Debian ISOs:** https://cdimage.debian.org/cdimage/release/
- **Vagrant Cloud:** https://app.vagrantup.com/wesdemos
