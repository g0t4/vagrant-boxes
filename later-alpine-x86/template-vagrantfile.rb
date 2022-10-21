# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

  config.vm.boot_timeout = 1800
  # TODO keep? # config.vm.synced_folder ".", "/vagrant", disabled: true

  config.vm.provider :virtualbox do |v, override|
    v.gui = false
    # modifyvm docs: https://docs.oracle.com/en/virtualization/virtualbox/7.0/user/vboxmanage.html
    #   run `vboxmanage` without args to see flags to modifyvm in help output
    #   check current value: `VBoxManage showvminfo VMIDorNAME --machinereadable | grep -i chipset`
    v.customize ["modifyvm", :id, "--vram", 128]
    v.customize ["modifyvm", :id, "--graphicscontroller", "vmsvga"] # none | vboxvga | vmsvga | vboxsvga
    v.customize ["modifyvm", :id, "--cpus", 2]
    v.customize ["modifyvm", :id, "--memory", 2048]
    v.customize ["modifyvm", :id, "--audio", "none"] # disable audio
    v.customize ["modifyvm", :id, "--chipset", "ich9"] # ich9 | piix3
    v.customize ["modifyvm", :id, "--nested-paging", "off"] # on | off
    v.customize ["modifyvm", :id, "--paravirt-provider", "none"] # --paravirt-provider= none | default | legacy | minimal | hyperv | kvm
    # note: --paravirt-provider modifies both paravirtprovider & effparavirtprovider in showvminfo output
    
 
 
  end

end
