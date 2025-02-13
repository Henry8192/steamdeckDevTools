#!/bin/bash

# Check if the script is being run as root
if [[ $(id -u) -ne 0 ]]; then
    echo "This script must be run as root."
    exit 1
fi

# Unlock steamdeck filesystem
steamos-readonly disable
# Initialize pacman keyring
pacman-key --init
pacman-key --populate archlinux

# Remove fakeroot.conf if it exists
fakeroot_conf="/etc/ld.so.conf.d/fakeroot.conf"
if [[ -f "$fakeroot_conf" ]]; then
    rm "$fakeroot_conf"
    echo "Removed $fakeroot_conf"
fi

pacman -Sy --noconfirm base-devel cmake glibc linux-headers linux-api-headers npm
# pacman -Sy --noconfirm wireguard-tools
# mkdir /etc/wireguard
# cp wg0.conf /etc/wireguard/wg0.conf
echo "Packages installed successfully."
