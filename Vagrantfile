# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

$master_script = <<SCRIPT
#!/bin/bash
cat > /etc/hosts <<EOF
127.0.0.1       localhost

# The following lines are desirable for IPv6 capable hosts
::1     ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters

192.168.50.100   dse-node01
192.168.50.101   dse-node02
EOF

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
cat > /etc/hosts <<EOF
127.0.0.1       localhost

# The following lines are desirable for IPv6 capable hosts
::1     ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters

192.168.50.100   dse-node01
192.168.50.101   dse-node02
EOF

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
service dse start
ufw disable

SCRIPT

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"
  config.vm.define "dse-node01" do |vm0|
    vm0.vm.box = "Ubuntu"
    vm0.vm.provider "virtualbox" do |v|
      v.memory = 4096
      v.cpus = 2
    end
    vm0.vm.network "private_network", ip: "192.168.50.100"
    vm0.vm.hostname = "dse-node01"
    vm0.vm.provision :shell, :inline => $master_script
  end

  config.vm.define "dse-node02" do |vm1|
    vm1.vm.box = "Ubuntu"
    vm1.vm.provider "virtualbox" do |v|
      v.memory = 4096
      v.cpus = 2
    end    
    vm1.vm.network "private_network", ip: "192.168.50.101"
    vm1.vm.hostname = "dse-node02"
    vm1.vm.provision :shell, :inline => $slave_script
  end



end
