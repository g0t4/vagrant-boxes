#!/usr/bin/env fish

vagrant_cloud_token

# validate both builds
packer validate -var-file="12/pkrvars.hcl" .

# fmt all files
packer fmt .
packer fmt 12/pkrvars.hcl
