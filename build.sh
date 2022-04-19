#!/bin/bash

sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg lsb-release git
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io -y

sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

mkdir -p /opt

git clone https://github.com/LumeWeb/dns-relay-stack -b develop /opt/dnsrelay

mkdir /opt/dnsrelay/data
touch /opt/dnsrelay/data/.env


wget -O vultr-helper.sh https://raw.githubusercontent.com/vultr/vultr-marketplace/main/helper-scripts/vultr-helper.sh
chmod +x vultr-helper.sh
. vultr-helper.sh

################################################
## Prepare server for Marketplace snapshot
error_detect_on
clean_system

exit 0
