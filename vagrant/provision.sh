#!/bin/bash

set -ex

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get --yes upgrade make awscli

# Install docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
apt-get install --yes docker-ce docker-ce-cli containerd.io
usermod -aG docker vagrant

curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

PREFILIGHT_VERSION="1.9.6"
wget "https://github.com/redhat-openshift-ecosystem/openshift-preflight/releases/download/${PREFILIGHT_VERSION}/preflight-linux-amd64"
mv preflight-linux-amd64 preflight
chmod +x preflight
mv preflight /usr/local/bin/preflight
