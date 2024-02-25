#!/usr/bin/env fish

vagrant_cloud_token

# validate both builds
packer validate -var-file="emulated/pkrvars.hcl" .
packer validate -var-file="native/pkrvars.hcl" .

# fmt all files
packer fmt .
packer fmt emulated/pkrvars.hcl
packer fmt native/pkrvars.hcl
