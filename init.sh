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

PACMAN_CONF="/etc/pacman.conf"

# Change the SigLevel to TrustAll in /etc/pacman.conf
if [[ -f "$PACMAN_CONF" ]]; then
    # Use sed to replace the existing 'SigLevel' line, or insert it if not found under the [options] section.
    # This sed command is complex to handle various cases:
    # 1. If SigLevel is present, it changes it to TrustAll.
    # 2. If [options] is present but SigLevel is not, it inserts SigLevel = TrustAll after [options].
    # 3. It tries to be careful to only modify the SigLevel in the main [options] block.

    # A simpler and more common approach that assumes a standard pacman.conf format
    # (i.e., 'SigLevel = PackageRequired' is present in the main options block) is:

    if grep -qE '^\s*SigLevel\s*=\s*.*' "$PACMAN_CONF"; then
        # If SigLevel line exists, replace it
        sed -i '/^\s*SigLevel\s*=\s*/c\SigLevel = TrustAll' "$PACMAN_CONF"
        echo "Changed SigLevel to TrustAll in $PACMAN_CONF"
    else
        # If SigLevel line doesn't exist, try to insert it after [options]
        # Note: This insertion point might not be ideal depending on the file's structure.
        # It's safer if it's expected to be present.
        sed -i '/^\[options\]/a SigLevel = TrustAll' "$PACMAN_CONF"
        echo "Inserted SigLevel = TrustAll in $PACMAN_CONF"
    fi
else
    echo "Warning: $PACMAN_CONF not found."
fi

# Remove fakeroot.conf if it exists
fakeroot_conf="/etc/ld.so.conf.d/fakeroot.conf"
if [[ -f "$fakeroot_conf" ]]; then
    rm "$fakeroot_conf"
    echo "Removed $fakeroot_conf"
fi

pacman -Sy --needed --noconfirm base-devel cmake glibc linux-headers linux-api-headers npm
# pacman -Sy --noconfirm wireguard-tools
# mkdir /etc/wireguard
# cp wg0.conf /etc/wireguard/wg0.conf
echo "Packages installed successfully."
