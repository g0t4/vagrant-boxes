#!/usr/bin/env fish

vagrant_cloud_token

# temp workaround for parallels virtualization sdk
export PYTHONPATH=/Library/Frameworks/ParallelsVirtualizationSDK.framework/Versions/Current/Libraries/Python/3.7

packer build -on-error ask -timestamp-ui \
  -var-file="2404/pkrvars.hcl" \
  -var="client_id=${VAGRANT_HCP_CLIENT_ID}" \
  -var="client_secret=${VAGRANT_HCP_CLIENT_SECRET}" \
  .
