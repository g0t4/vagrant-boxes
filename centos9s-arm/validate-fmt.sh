#!/usr/bin/env fish

# Note: uses vagrant-cloud post-processor (older API) which requires auth during validate.
# Only run fmt here - validation requires real VAGRANT_CLOUD_TOKEN.

# fmt all files
packer fmt .
packer fmt pkrvars.hcl
