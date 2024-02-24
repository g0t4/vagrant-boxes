echo 'FYI if get FAILURE finding "Host IP...", workaround: change host nic (bound to network) to en0 to en9, check w/ ifconfig... anything over en10 wont work with current parallels+packer plugin'

echo "trashing previous *.box builds... can recover from trash if a mistake"
echo "   " *.box
trash *.box

# temp workaround for parallels virtualization sdk
export PYTHONPATH=/Library/Frameworks/ParallelsVirtualizationSDK.framework/Versions/10/Libraries/Python/3.7

packer build -on-error ask -timestamp-ui \
  -var-file="pkrvars.hcl" \
  .

