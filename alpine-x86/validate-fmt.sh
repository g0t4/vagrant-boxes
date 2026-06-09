#!/usr/bin/env fish

# validate both builds
packer validate -var-file="emulated/pkrvars.hcl" \
    -var="client_id=dummy" \
    -var="client_secret=dummy" .
packer validate -var-file="native/pkrvars.hcl" \
    -var="client_id=dummy" \
    -var="client_secret=dummy" .

# fmt all files
packer fmt .
packer fmt emulated/pkrvars.hcl
packer fmt native/pkrvars.hcl
