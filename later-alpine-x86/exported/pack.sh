# make sure not to leave port forward rule on 2222->22 on vbox VM - remove before packing below
#
# tar -czf manual.box box.ovf metadata.json info.json
vagrant package --base test --output alpine-x86.box
# have to mod Vagrantfile to add config.ssh.shell = "ash" # or add add bash package to env... 
# make a new temp dir:
#   take tmp
# copy box into tmp:
#   cp ../foo.box .
# expand archive so can modify Vagrantfile:
#   tar tvf foo.box # list files to make sure add all back
#   tar xvf foo.box
# modify files:
#   vim Vagrantfile # add in `config.ssh.shell = "ash"`
# package up box again:
#   tar czf fix.box Vagrantfile box-disk002.vmdk box.ovf metadata.json 
#   # use whatever files were in original archive
# test local
#   vagrant box add fix fix.box 
#   take test
#     vagrant init fix
#     vagrant up  # make sure fully starts up and no shell error
#     vagrant halt # make sure doesn't have shell error
#     vagrant destory -f # nuke test box
#   vagrant box rm fix
# add to vagrantcloud as new version and release it
#   sha256sum fix.box # need for upload to vagrant cloud
#
# check vagrant guides for creating boxes for any specifics (checklist) both general docs and virtualbox specific docs
#   general: https://www.vagrantup.com/docs/boxes/base
#     https://www.vagrantup.com/docs/boxes
#     https://www.vagrantup.com/docs/boxes/format
#   virtualbox specific: https://developer.hashicorp.com/vagrant/docs/providers/virtualbox/boxes?optInFrom=vagrant-io

# docs - creating a virtualbox base box:
#   https://www.vagrantup.com/docs/providers/virtualbox/boxes
# 
# box format (files)
#   https://www.vagrantup.com/docs/boxes/format
