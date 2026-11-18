#!/usr/bin/env bash

# Stop execution on any error
set -e

COLS=$(tput cols)

# if user is not running the command as root
if [ "$UID" -ne 0 ]; then
    echo "Please run the installer with SUDO!"
    exit
fi

print_title() {
    local title="$1"
    printf '%*s\n' "$COLS" '' | tr ' ' '='
    printf '%*s\n' $(( (COLS + ${#title}) / 2 )) "$title"
    printf '%*s\n' "$COLS" '' | tr ' ' '='
}

print_title "Installing Dependencies"

if [ -x "$(command -v dnf)" ]; then
    dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm
    dnf update -yq

    # For CentOS Stream 9
    dnf --enablerepo=crb install libzip-devel oniguruma-devel

    dnf install -yq wget gcc make libxml2-devel sqlite-devel libcurl-devel gd-devel libsodium-devel
elif [ -x "$(command -v apt)" ]; then
    apt update -yq
    apt install -yq wget gcc make 
else
    echo "Neither dnf nor apt found. Exiting."
    exit 1
fi

PHP_VER=8.4.16
WORKDIR=$(mktemp -d)

cd "$WORKDIR"

echo "Downloading PHP $PHP_VER..."
wget -q https://www.php.net/distributions/php-$PHP_VER.tar.gz
tar -xzf php-$PHP_VER.tar.gz
cd php-$PHP_VER

./configure \
    --sysconfdir=/etc/php/8.4/cli \
    --with-config-file-path=/etc/php/8.4/cli \
    --with-config-file-scan-dir=/etc/php/8.4/cli/conf.d \
    --disable-cgi --enable-cli \
    --prefix=/usr --with-curl --with-zip --with-zlib --with-openssl \
    --with-sodium --with-pdo-mysql=mysqlnd --enable-gd --enable-mbstring \
    --enable-soap --enable-sockets

make -j"$(nproc)"
make install
