echo "trashing previous *.box builds... can recover from trash if a mistake"
echo "   " *.box
trash *.box

# temp workaround for parallels virtualization sdk
export PYTHONPATH=/Library/Frameworks/ParallelsVirtualizationSDK.framework/Versions/10/Libraries/Python/3.7

packer build -on-error ask -timestamp-ui .
