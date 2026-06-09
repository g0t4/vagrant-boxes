# Qwen Reference: Ubuntu/Arch Linux Box Updates & Creation

## Quick Reference

### 1. Check for New ISOs

**Ubuntu Official Releases:**
```bash
# Check latest release
curl -sL https://cdimage.ubuntu.com/releases/<VERSION>/release/ | grep -i "live-server-arm64"

# Get checksums
curl -sL https://cdimage.ubuntu.com/releases/<VERSION>/release/SHA256SUMS | grep arm64
```

**Ubuntu Daily-Live (dev releases):**
```bash
# Check daily-live (only available during development cycle)
curl -sL https://cdimage.ubuntu.com/ubuntu-server/daily-live/current/ | grep -i "live-server-arm64"
```

**Ubuntu Snapshots (early test builds):**
```bash
# Check snapshots (published before daily-live starts)
curl -sL https://cdimage.ubuntu.com/releases/<VERSION>/snapshot-1/ | grep -i "live-server-arm64"
```

**Arch Linux (Archboot for ARM):**
```bash
# Arch only ships x86_64 officially; use archboot for aarch64
curl -sL https://release.archboot.com/aarch64/latest/iso/ | grep -i "aarch64"

# Get checksums (Archboot provides BLAKE2b only)
curl -sL https://release.archboot.com/aarch64/latest/b2sum.txt | grep -i "aarch64-ARCH-aarch64.iso"
```

### 2. Compute SHA256 for Archboot (BLAKE2b → SHA256)

Packer doesn't support BLAKE2b natively, so download and compute:
```bash
cd /tmp
curl -L -o archboot.iso https://release.archboot.com/aarch64/latest/iso/<ISO_NAME>
shasum -a 256 archboot.iso
rm archboot.iso
```

### 3. Update Existing Box Version (e.g., 26.04 daily-live → official)

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

### 4. Create New Box Version Directory

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

### 5. Validate and Format

```bash
cd ubuntu-arm
fish validate-fmt.fish
```

This runs:
- `packer validate -var-file="<dir>/pkrvars.hcl"` for each version
- `packer fmt <dir>/pkrvars.hcl` to auto-format HCL files

### 6. Run the Build

**With credentials (full build + Vagrant Cloud upload):**
```bash
cd ubuntu-arm
./build.<VERSION>.fish
# or: fish build.<VERSION>.fish
```

**Without credentials (local box only, for testing):**
```bash
cd ubuntu-arm
packer build -var-file="<VERSION>/pkrvars.hcl" .
```

**Expected output:**
- Build takes ~7-10 minutes
- Local box created at `out/packer_ubuntu<VERSION>-arm_parallels.box`
- Vagrant Cloud upload to `wesdemos/ubuntu<VERSION>-arm` (version <box_version>)

### 7. Common Issues & Fixes

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
  -var="client_id=test" \
  -var="client_secret=test" \
  .
```

### 8. Commit Strategy

```bash
cd /Users/wes/repos/github/g0t4/vagrant-boxes
git add ubuntu-arm/<VERSION>/ ubuntu-arm/build.<VERSION>.fish ubuntu-arm/validate-fmt.fish
git commit -m "ubuntu-arm: add Ubuntu <VERSION> (<CODENAME>) build"
```

## Ubuntu Release Cycle Reference

| Phase | URL Pattern | Availability |
|-------|-------------|--------------|
| Snapshot (early test) | `releases/<VER>/snapshot-1/` | ~2 months before release |
| Daily-Live (dev) | `ubuntu-server/daily-live/current/` | ~1 month before release |
| Official Release | `releases/<VER>/release/` | On release day (April/October) |

## Key URLs

- **Ubuntu ISOs:** https://cdimage.ubuntu.com/
- **Archboot ARM:** https://release.archboot.com/aarch64/latest/iso/
- **Vagrant Cloud:** https://app.vagrantup.com/wesdemos
