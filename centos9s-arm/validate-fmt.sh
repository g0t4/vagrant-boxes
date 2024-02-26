#!/usr/bin/env fish

vagrant_cloud_token

packer validate -var-file="pkrvars.hcl" .

# fmt all files
packer fmt .
packer fmt pkrvars.hcl
