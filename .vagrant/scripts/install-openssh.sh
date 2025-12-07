#!/bin/bash

echo "--------------------------------"
echo "      Installing Dependencies"
echo "--------------------------------"

if [ -x "$(command -v dnf)" ]; then
    sudo dnf update -yq
    sudo dnf install -yq wget gcc make zlib-devel pam-devel
elif [ -x "$(command -v apt)" ]; then
    sudo apt update -yq
    sudo apt install -yq wget gcc make zlib1g-dev libpam0g-dev
else
    echo "Neither dnf nor apt found. Exiting."
    exit 1
fi

echo "--------------------------------"
echo "      Installing OpenSSH"
echo "--------------------------------"

openssh_ver=10.2p1

if [ "$(sshd -V 2>&1 | awk -F '[_,]' '{print $2}')" == "10.2p1" ]; then
    echo "OpenSSH version ${openssl_ver} is already installed."
else
    wget -q -O openssh-${openssh_ver}.tar.gz https://ftp.nluug.nl/pub/OpenBSD/OpenSSH/portable/openssh-${openssh_ver}.tar.gz
    tar -xzf openssh-${openssh_ver}.tar.gz
    cd openssh-${openssh_ver}

    ./configure --prefix=/usr --sysconfdir=/etc/ssh --with-pam --with-ssl-engine

    make -j$(nproc) 1> /dev/null

    sudo rm -f /etc/ssh/ssh_config /etc/ssh/sshd_config

    sudo make install 1> /dev/null
    
    sudo chmod 600 /etc/ssh/ssh_host_*_key
    sudo chown root:root /etc/ssh/ssh_host_*_key

    cd ..
    
    rm openssh-${openssh_ver}.tar.gz
    rm -R openssh-${openssh_ver}

    sudo systemctl restart sshd
    #systemctl status sshd
    ssh -V
fi

exit 0