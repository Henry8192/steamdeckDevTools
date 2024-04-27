#!/bin/bash

# Check if the script is being run as root
if [[ $(id -u) -ne 0 ]]; then
    echo "This script must be run as root."
    exit 1
fi

# Initialize pacman keyring
pacman-key --init
pacman-key --populate archlinux

# Remove fakeroot.conf if it exists
fakeroot_conf="/etc/ld.so.conf.d/fakeroot.conf"
if [[ -f "$fakeroot_conf" ]]; then
    rm "$fakeroot_conf"
    echo "Removed $fakeroot_conf"
fi

# Install base-devel, linux-headers, linux-api-headers, and glibc packages
pacman -Sy --noconfirm base-devel linux-headers linux-api-headers glibc npm

echo "Packages installed successfully."

