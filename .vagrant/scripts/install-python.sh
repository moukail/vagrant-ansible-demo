#!/usr/bin/env bash

echo "--------------------------------"
echo "    Installing Dependencies     "
echo "--------------------------------"

if [ -x "$(command -v dnf)" ]; then
    sudo dnf update -yq
    sudo dnf install -yq wget gcc make zlib-devel libffi-devel
elif [ -x "$(command -v apt)" ]; then
    sudo apt update -yq
    sudo apt install -yq wget gcc make zlib1g-dev libffi-dev
else
    echo "Neither dnf nor apt found. Exiting."
    exit 1
fi

echo "--------------------------------"
echo "      Installing Python         "
echo "--------------------------------"

PYTHON_VERSION=3.14.0

if [ "$(python3.14 --version | cut -f2 -d' ')" == $PYTHON_VERSION ]; then
    echo "Python version ${PYTHON_VERSION} is already installed."
else
    cd $(mktemp -d)
    wget -q https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz
    tar -xf Python-${PYTHON_VERSION}.tgz
    cd Python-${PYTHON_VERSION}

    ./configure --enable-optimizations --with-lto --enable-shared --prefix=/usr

    make -j$(nproc) 1> /dev/null
    sudo make altinstall

    echo "/usr/lib" | sudo tee /etc/ld.so.conf.d/python3.14.conf
    sudo ldconfig

    python3.14 --version
    python3.14 -m ensurepip
    python3.14 -m pip install --upgrade pip
    python3.14 -m pip --version
fi