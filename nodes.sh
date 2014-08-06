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
