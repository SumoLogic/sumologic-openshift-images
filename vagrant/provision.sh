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

if [[ "${ARCH}" == "arm64" ]]; then
   export GO_VERSION="1.21.4"
   # Install Go
   curl -LJ "https://golang.org/dl/go${GO_VERSION}.linux-${ARCH}.tar.gz" -o go.linux-${ARCH}.tar.gz \
      && rm -rf /usr/local/go \
      && tar -C /usr/local -xzf go.linux-${ARCH}.tar.gz \
      && rm go.linux-${ARCH}.tar.gz \
      && ln -s /usr/local/go/bin/go /usr/local/bin
   cd /sumologic
   make build_preflight
else
   wget "https://github.com/redhat-openshift-ecosystem/openshift-preflight/releases/latest/download/preflight-linux-amd64"
   mv preflight-linux-amd64 preflight
   chmod +x preflight
   mv preflight /usr/local/bin/preflight
fi
