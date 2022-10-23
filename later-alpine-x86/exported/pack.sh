# make sure not to leave port forward rule on 2222->22 on vbox VM - remove before packing below
#
# tar -czf manual.box box.ovf metadata.json info.json
vagrant package --base test --output alpine-x86.box


# docs - creating a virtualbox base box:
#   https://www.vagrantup.com/docs/providers/virtualbox/boxes
# 
# box format (files)
#   https://www.vagrantup.com/docs/boxes/format
