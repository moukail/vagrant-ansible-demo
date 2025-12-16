#!/bin/bash

COLS=$(tput cols)

# if user is not running the command as root
if [ "$UID" -ne 0 ]; then
    echo "Please run the installer with SUDO!"
    exit
fi

title="Installing Dependencies for OpenSSL"

printf '%*s\n' "$COLS" '' | tr ' ' '='
printf '%*s\n' $(( (COLS + ${#title}) / 2 )) "$title"
printf '%*s\n' "$COLS" '' | tr ' ' '='

if [ -x "$(command -v dnf)" ]; then
    dnf update -yq
    dnf install -yq wget gcc make perl zlib-devel
elif [ -x "$(command -v apt)" ]; then
    apt update -yq
    apt install -yq wget gcc make perl zlib1g-dev
else
    echo "Neither dnf nor apt found. Exiting."
    exit 1
fi

title="Installing OpenSSL"

printf '%*s\n' "$COLS" '' | tr ' ' '='
printf '%*s\n' $(( (COLS + ${#title}) / 2 )) "$title"
printf '%*s\n' "$COLS" '' | tr ' ' '='

openssl_ver=3.6.0

if [ "$(openssl version | awk '{print $2}')" == "${openssl_ver}" ]; then
    echo "OpenSSL version ${openssl_ver} is already installed."
else
    cd $(mktemp -d)
    wget -q https://github.com/openssl/openssl/releases/download/openssl-${openssl_ver}/openssl-${openssl_ver}.tar.gz
    tar -xzf openssl-${openssl_ver}.tar.gz
    cd openssl-${openssl_ver}

    # redhat 9 needs enabling md2
    ./Configure --prefix=/usr --libdir=/usr/lib/x86_64-linux-gnu --openssldir=/etc/ssl shared zlib enable-md2

    make -j$(nproc)
    make install

    echo "/usr/lib64" > /etc/ld.so.conf.d/openssl.conf
    ldconfig

    openssl version
fi

exit 0
