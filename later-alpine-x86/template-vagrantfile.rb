# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

  config.vm.boot_timeout = 1800
  # TODO keep? # config.vm.synced_folder ".", "/vagrant", disabled: true

  config.vm.provider :virtualbox do |v, override|
    v.gui = false
    # modifyvm docs: https://docs.oracle.com/en/virtualization/virtualbox/7.0/user/vboxmanage.html
    v.customize ["modifyvm", :id, "--vram", 256]
    v.customize ["modifyvm", :id, "--cpus", 2]
    v.customize ["modifyvm", :id, "--memory", 2048]
    # todo x86 mods
  end

end
