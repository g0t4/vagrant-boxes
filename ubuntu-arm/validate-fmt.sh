
# validate both builds
packer validate -var-file="2204/pkrvars.hcl" .
packer validate -var-file="2310/pkrvars.hcl" .

# fmt all files
packer fmt .
packer fmt 2204/pkrvars.hcl
packer fmt 2310/pkrvars.hcl
