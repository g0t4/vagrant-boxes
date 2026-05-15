# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a Packer-based repository for building Vagrant boxes targeting ARM64 (Apple Silicon). The `ubuntu-arm/` directory is the primary focus. Parallel directories exist for other distros: `arch-arm/`, `debian-arm/`, `centos9s-arm/`, `alpine-x86/`.

All boxes are published to HashiCorp Cloud Platform (HCP) Vagrant Registry under the `wesdemos` organization.

## Build Commands

Validate and format HCL before building:
```fish
./validate-fmt.fish
```

Build a specific Ubuntu version (requires HCP credentials):
```fish
./build.2604.fish   # Ubuntu 26.04
./build.2404.fish   # Ubuntu 24.04 LTS
./build.2510.fish   # Ubuntu 25.10
./build.2204.fish   # Ubuntu 22.04 LTS
```

Each build script expects `VAGRANT_HCP_CLIENT_ID` and `VAGRANT_HCP_CLIENT_SECRET` env vars (loaded via the `vagrant_cloud_token` Fish function). Raw packer invocation:
```fish
packer build -on-error ask -timestamp-ui -var-file="2604/pkrvars.hcl" \
  -var="client_id=$VAGRANT_HCP_CLIENT_ID" -var="client_secret=$VAGRANT_HCP_CLIENT_SECRET" .
```

Test a built box locally using the version-specific `Vagrantfile` (e.g., `2604/Vagrantfile`), which references `../out/packer_ubuntu*_parallels.box`.

## Architecture

**`build.pkr.hcl`** — Single Packer HCL file for all Ubuntu versions. Uses Parallels as the hypervisor (macOS/Apple Silicon only). Requires Parallels Virtualization SDK (PYTHONPATH set in build scripts).

**`{version}/pkrvars.hcl`** — Version-specific variables: ISO URL/checksums, boot wait times, box version/description, HCP org (`wesdemos`).

**`http/user-data`** — Cloud-init autoinstall config injected via HTTP server during boot. Configures `vagrant` user, SSH, locale, networking (DHCP on `enp0s5`).

**`scripts/`** — Provisioning scripts run in order: `sudoers.sh`, `apt.sh`, `parallels.tools.sh`, `networking.sh`, `cleanup.sh`.

**Output:** Built boxes land in `out/packer_ubuntu{version}-arm_parallels.box` then get uploaded to HCP.

## SSH Timing During Ubuntu Autoinstall

If builds fail due to SSH connection issues, see `notes/ssh-quirks-ubuntu.md`. The `boot_wait` and `ssh_handshake_attempts` values in `build.pkr.hcl`/`pkrvars.hcl` control how Packer waits for the installer to finish before connecting.
