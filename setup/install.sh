#!/bin/bash

echo "=== MX·Link·XP Linux-side Installer ==="

# 1. Define BIN_DIR
BIN_DIR="/usr/local/bin"

# 2. Ask for ramdisk size
read -p "Enter ramdisk size (default: 512M): " RAMDISK_SIZE
RAMDISK_SIZE=${RAMDISK_SIZE:-512M}

# 3. Copy binaries
echo "Copying binaries to $BIN_DIR..."
sudo cp -v ./Ajavahti/ajavahti "$BIN_DIR/"
sudo cp -v ./Iniwriter/iniwriter "$BIN_DIR/"
sudo cp -v ./xpasso/xpasso "$BIN_DIR/"

# 4. Setup ramdisk
RAMDISK_DIR="$HOME/ramdisk"
echo "Creating and mounting ramdisk at $RAMDISK_DIR with size $RAMDISK_SIZE..."
mkdir -p "$RAMDISK_DIR"

# Check if fstab entry already exists
if ! grep -q "$RAMDISK_DIR" /etc/fstab; then
    echo "Adding ramdisk to /etc/fstab..."
    echo "tmpfs   $RAMDISK_DIR   tmpfs   size=$RAMDISK_SIZE,mode=0755   0 0" | sudo tee -a /etc/fstab
fi

sudo mount "$RAMDISK_DIR"

# 5. Auto-start ajavahti at boot (basic xprofile method)
echo "Adding ajavahti to ~/.xprofile for autostart..."
echo "$BIN_DIR/ajavahti &" >> ~/.xprofile

# 6. Done
echo "✅ Installation complete."
echo "Ramdisk and ajavahti will start automatically at boot."

# 7. Ask for reboot
read -p "Do you want to reboot now? (y/n): " REBOOT
if [[ "$REBOOT" == "y" || "$REBOOT" == "Y" ]]; then
    sudo reboot
fi
