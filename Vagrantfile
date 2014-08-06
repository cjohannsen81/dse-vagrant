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
        config.vm.provision :shell, :inline => $master_script
      else
        config.vm.provision :shell, :inline => $slave_script
        config.vm.provision :shell, :inline => "sed -i 's/listen_address:.*$/listen_address: #{val[:ip]}/' /etc/dse/cassandra/cassandra.yaml"
      end

    end
  end


$master_script = <<SCRIPT
#!/bin/bash
apt-get update
apt-get install -q -y openjdk-7-jdk 
java -version
apt-get install -q -y curl
curl -L https://debian.datastax.com/debian/repo_key | sudo apt-key add -
echo "Configure the first node with opscenter..."
cat > /etc/apt/sources.list.d/datastax.sources.list <<EOF 
deb http://USERNAME:PASSWORD@debian.datastax.com/enterprise stable main
EOF
apt-get update 
apt-get install -q -y dse-full opscenter
scp /vagrant/cassandra-first.yaml /etc/dse/cassandra/cassandra.yaml
service dse start
ufw disable
service opscenterd start
SCRIPT

$slave_script = <<SCRIPT
#!/bin/bash
apt-get update
apt-get install -q -y openjdk-7-jdk
java -version
apt-get install -q -y curl
curl -L https://debian.datastax.com/debian/repo_key | sudo apt-key add -
echo "Configure the node..."
cat > /etc/apt/sources.list.d/datastax.sources.list <<EOF
deb http://USERNAME:PASSWORD@debian.datastax.com/enterprise stable main
EOF
apt-get update
apt-get install -q -y dse-full
scp /vagrant/cassandra-second.yaml /etc/dse/cassandra/cassandra.yaml
sed -i 's/seeds: \"\"/seeds: \"192.168.50.100\"/' /etc/dse/cassandra/cassandra.yaml
sed -i 's/rpc_address:.*$/rpc_address: 0.0.0.0/' /etc/dse/cassandra/cassandra.yaml
service dse start
ufw disable
SCRIPT

end

end
