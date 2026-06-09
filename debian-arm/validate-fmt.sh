#!/usr/bin/env fish

# validate both builds
packer validate -var-file="12/pkrvars.hcl" \
    -var="client_id=dummy" \
    -var="client_secret=dummy" .

# fmt all files
packer fmt .
packer fmt 12/pkrvars.hcl
