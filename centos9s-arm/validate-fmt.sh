packer validate -var-file="pkrvars.hcl" .

# fmt all files
packer fmt .
packer fmt pkrvars.hcl