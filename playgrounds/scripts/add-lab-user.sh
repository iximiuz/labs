#!/bin/sh
set -eu

USER_ID=1001
USERNAME="${LAB_USER}"
PASSWORD="${LAB_USER}"

if [ -f /etc/almalinux-release ] || [ -f /etc/fedora-release ] || [ -f /etc/rocky-release ]; then
    adduser --comment "" --uid "$USER_ID" "$USERNAME"
elif [ -f /etc/arch-release ] || [ -f /etc/products.d/openSUSE.prod ]; then
    useradd -m -c "" -u "$USER_ID" "$USERNAME"
else
    adduser --disabled-password --gecos "" --uid "$USER_ID" "$USERNAME"
fi

# Set the user's password
echo "$USERNAME:$PASSWORD" | sudo chpasswd

SUDO_GROUP="sudo"
# Determine the sudo group based on the distribution
if [ -f /etc/almalinux-release ]; then
    SUDO_GROUP="wheel"
elif [ -f /etc/arch-release ]; then
    SUDO_GROUP="wheel"
elif [ -f /etc/fedora-release ]; then
    SUDO_GROUP="wheel"
elif [ -f /etc/rocky-release ]; then
    SUDO_GROUP="wheel"
elif [ -f /etc/products.d/openSUSE.prod ]; then
    SUDO_GROUP="wheel"
fi

# Add the user to the sudo group
usermod -aG "$SUDO_GROUP" "$USERNAME"

# Grant no-password sudo privileges
echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/$USERNAME

# Set proper permissions for the sudoers file
chmod 0440 /etc/sudoers.d/$USERNAME