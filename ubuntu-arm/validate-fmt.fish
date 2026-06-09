#!/usr/bin/env fish

# Use dummy credentials for validation/formatting (no real secrets needed)
set DUMMY_CLIENT_ID "dummy"
set DUMMY_CLIENT_SECRET "dummy"

function validate
    set file $argv[1]
    packer validate -var-file="$file" \
        -var="client_id=$DUMMY_CLIENT_ID" \
        -var="client_secret=$DUMMY_CLIENT_SECRET" \
        .
end

# TODO test isos for 2204 if I still want that
validate "2204/pkrvars.hcl"
validate "2404/pkrvars.hcl"
validate "2510/pkrvars.hcl"
validate "2604/pkrvars.hcl"
validate "2610/pkrvars.hcl"

packer fmt 2204/pkrvars.hcl
packer fmt 2404/pkrvars.hcl
packer fmt 2510/pkrvars.hcl
packer fmt 2604/pkrvars.hcl
packer fmt 2610/pkrvars.hcl
