#!/usr/bin/env fish

vagrant_cloud_token

# temp workaround for parallels virtualization sdk
export PYTHONPATH=/Library/Frameworks/ParallelsVirtualizationSDK.framework/Versions/Current/Libraries/Python/3.7

packer build -on-error ask -timestamp-ui \
  -var-file="2310/pkrvars.hcl" \
  .
