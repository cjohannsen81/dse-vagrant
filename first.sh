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
