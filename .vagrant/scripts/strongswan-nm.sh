#!/usr/bin/env bash

# Stop execution on any error
set -e

sudo subscription-manager repos --enable codeready-builder-for-rhel-10-x86_64-rpms

sudo dnf install -y \
  gcc \
  make \
  NetworkManager-libnm-devel \
  gmp-devel

VERSION=5.9.14
WORKDIR=$(mktemp -d)

cd "$WORKDIR"

echo "Backend"
echo "Downloading strongswan $VERSION..."
wget -q wget https://download.strongswan.org/strongswan-$VERSION.tar.gz
tar -xzf strongswan-$VERSION.tar.gz

cd strongswan-$VERSION
echo "Compiling strongswan with NetworkManager support..."

./configure --sysconfdir=/etc --prefix=/usr --libexecdir=/usr/lib \
   --disable-aes --disable-des --disable-md5 --disable-sha1 --disable-sha2 \
   --disable-fips-prf --disable-gmp --enable-openssl --enable-nm --enable-agent \
   --enable-eap-gtc --enable-eap-md5 --enable-eap-mschapv2 --enable-eap-identity

make
sudo make install




sudo dnf install -y gtk4-devel libadwaita-devel NetworkManager-libnm-devel libnma-devel \
  glib2-devel cairo-devel pango-devel gdk-pixbuf2-devel pkgconf-pkg-config libsecret-devel

wget https://download.strongswan.org/NetworkManager/NetworkManager-strongswan-1.6.4.tar.bz2
tar xf NetworkManager-strongswan-1.6.4.tar.bz2
cd NetworkManager-strongswan-1.6.4

./configure --sysconfdir=/etc --prefix=/usr
make
make install