# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

boxes = [
  { :name => 'dse-node0', :ip => '192.168.50.100', :cpus =>2, :memory => 4096 },
  { :name => 'dse-node1', :ip => '192.168.50.101', :cpus =>2, :memory => 4096 },
  { :name => 'dse-node2', :ip => '192.168.50.102', :cpus =>2, :memory => 4096 } 
]

Vagrant.configure("2") do |config|
  config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"
  boxes.each do |val|
    config.vm.define val[:name] do |config|
      config.vm.box = "Ubuntu"
      config.vm.provider :virtualbox do |v|
        v.customize ["modifyvm", :id, "--memory", val[:memory]]
        v.customize ["modifyvm", :id, "--cpus", val[:cpus] ] 
      config.vm.network :private_network, ip: val[:ip]
      config.vm.provision :shell, :inline => "cp -fv /vagrant/hosts /etc/hosts"
      if val[:name] == "dse-node0"
        #config.vm.provision :shell, :inline => $master_script
        config.vm.provision :shell, :path => "first.sh"
      else
        #config.vm.provision :shell, :inline => $slave_script
        config.vm.provision :shell, :path => "nodes.sh"
        config.vm.provision :shell, :inline => "sed -i 's/listen_address:.*$/listen_address: #{val[:ip]}/' /etc/dse/cassandra/cassandra.yaml"
      end

    end
  end
end

end
