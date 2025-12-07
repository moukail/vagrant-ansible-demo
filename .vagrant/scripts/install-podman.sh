#!/bin/bash

echo "--------------------------------"
echo "      Installing Dependencies"
echo "--------------------------------"

if [ -x "$(command -v dnf)" ]; then
    sudo dnf update -yq

elif [ -x "$(command -v apt)" ]; then
    sudo apt update -yq
    sudo apt install -yq btrfs-progs gcc git golang-go go-md2man iptables libassuan-dev libbtrfs-dev \
      libc6-dev libdevmapper-dev libglib2.0-dev libgpgme-dev libgpg-error-dev libprotobuf-dev \
      libprotobuf-c-dev libseccomp-dev libselinux1-dev libsystemd-dev make \
      pkg-config runc uidmap netavark passt
else
    echo "Neither dnf nor apt found. Exiting."
    exit 1
fi

cd $(mktemp -d)

echo "--------------------------------"
echo "      Installing Go Lang        "
echo "--------------------------------"

wget https://go.dev/dl/go1.25.4.linux-amd64.tar.gz
sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go1.25.4.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin
go version

echo "--------------------------------"
echo "      Installing Podman         "
echo "--------------------------------"

git clone https://github.com/containers/podman/
cd podman
make BUILDTAGS="selinux seccomp" PREFIX=/usr
sudo env PATH=$PATH make install PREFIX=/usr