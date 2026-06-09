#!/usr/bin/env fish

packer validate -var-file="pkrvars.hcl" \
    -var="client_id=dummy" \
    -var="client_secret=dummy" .

# fmt all files
packer fmt .
packer fmt pkrvars.hcl
