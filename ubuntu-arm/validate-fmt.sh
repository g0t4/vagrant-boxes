#!/usr/bin/env fish

vagrant_cloud_token

# validate both builds
# packer validate -var-file="2204/pkrvars.hcl" .
# packer validate -var-file="2410/pkrvars.hcl" .
packer validate -var-file="2404/pkrvars.hcl" \
    -var="client_id=$VAGRANT_HCP_CLIENT_ID" \
    -var="client_secret=$VAGRANT_HCP_CLIENT_SECRET" \
    .

# fmt all files
packer fmt .
packer fmt 2204/pkrvars.hcl
packer fmt 2410/pkrvars.hcl
packer fmt 2404/pkrvars.hcl
