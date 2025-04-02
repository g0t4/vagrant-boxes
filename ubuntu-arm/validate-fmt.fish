#!/usr/bin/env fish

vagrant_cloud_token

function validate
    set file $argv[1]
    packer validate -var-file="$file" \
        -var="client_id=$VAGRANT_HCP_CLIENT_ID" \
        -var="client_secret=$VAGRANT_HCP_CLIENT_SECRET" \
        .
end

# TODO test isos for 2204 if I still want that
# validate "2204/pkrvars.hcl"
validate "2404/pkrvars.hcl"
validate "2504/pkrvars.hcl"

packer fmt 2204/pkrvars.hcl
packer fmt 2504/pkrvars.hcl
packer fmt 2404/pkrvars.hcl
