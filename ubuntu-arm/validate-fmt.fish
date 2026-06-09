#!/usr/bin/env fish

function validate
    set file $argv[1]
    packer validate -var-file="$file" \
        -var="client_id=dummy" \
        -var="client_secret=dummy" \
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
