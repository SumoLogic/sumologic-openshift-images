#!/bin/bash

set -euo pipefail

LSB_RELEASE="$(lsb_release -cs)"
ARCH="$(dpkg --print-architecture)"

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get --yes upgrade make awscli

# Install docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository \
   "deb [arch=${ARCH}] https://download.docker.com/linux/ubuntu \
   ${LSB_RELEASE} \
   stable"
apt-get install -y docker-ce docker-ce-cli containerd.io
usermod -aG docker vagrant

curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

wget "https://github.com/redhat-openshift-ecosystem/openshift-preflight/releases/latest/download/preflight-linux-amd64"
mv preflight-linux-amd64 preflight
chmod +x preflight
mv preflight /usr/local/bin/preflight
