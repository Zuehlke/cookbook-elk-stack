# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure(2) do |config|

  # Ensure we have the required plugins installed
  required_plugins = ["vagrant-berkshelf", "vagrant-omnibus"]
  required_plugins.each do |plugin|
    unless Vagrant.has_plugin? plugin
      raise "the required plugin '#{plugin}' is not installed!"
    end
  end

  #
  # Set up an example ELK Stack VM
  #
  config.vm.define "elk-stack" do |cfg|

    cfg.vm.box = "bento/ubuntu-14.04"
    cfg.vm.hostname="elk-stack"

    # private network
    cfg.vm.network :private_network, ip: "192.168.33.15"

    # Port forward additional ports
    cfg.vm.network "forwarded_port", guest: 9200, host: 9200, id: "elastic", auto_correct: true
    cfg.vm.network "forwarded_port", guest: 80, host: 8080, id: "kibana", auto_correct: true

    cfg.vm.provider :virtualbox do |vbox, override|
      vbox.customize ["modifyvm", :id,
                      "--name", "elastic-test",
                      "--memory", 4096,
                      "--cpus", 2
      ]
    end

    cfg.vm.provider :vmware_workstation do |v, override|
      v.gui = true
      v.vmx["memsize"] = "4096"
      v.vmx["numvcpus"] = "1"
      v.vmx["cpuid.coresPerSocket"] = "2"
      v.vmx["ethernet0.virtualDev"] = "vmxnet3"
      v.vmx["RemoteDisplay.vnc.enabled"] = "false"
      v.vmx["RemoteDisplay.vnc.port"] = "5900"
      v.vmx["scsi0.virtualDev"] = "lsilogic"
    end

    cfg.omnibus.chef_version = "12.4.1"
    cfg.berkshelf.enabled = true

    cfg.vm.provision "chef_solo" do |chef|
      chef.add_recipe "elk-stack::default"
    end
  end



  #
  # some logging client VM
  #
  config.vm.define "log-client" do |ccu|
    ccu.vm.box = "bento/ubuntu-14.04"
    ccu.vm.network :private_network, ip: "192.168.33.14"
    ccu.vm.hostname = "log-client.local"
    ccu.berkshelf.enabled = false
    ccu.vm.provision "shell", inline: <<-EOH
      cat << CONF > /etc/rsyslog.d/60-fwd-remote.conf
local0.* @@192.168.33.15:10514
CONF
      sudo service rsyslog restart
      logger -p local0.info "first remote syslog entry!"
    EOH
  end

end
