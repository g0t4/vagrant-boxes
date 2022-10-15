
packer validate \
  -var-file="2204/pkrvars.hcl" \
  .

packer validate \
  -var-file="2210/pkrvars.hcl" \
  .

packer fmt \
  -var-file="2204/pkrvars.hcl" \
  .

packer fmt \
  -var-file="2210/pkrvars.hcl" \
  .
