#!/bin/bash
cd ..
echo "=== MX·Link·XP Installer ==="

# Ensure we are in the correct project directory
if [ ! -d "Ajavahti" ] || [ ! -d "Iniwriter" ] || [ ! -d "xpasso" ]; then
    echo "❌ Error: This script must be run from the project root directory."
    echo "   Required folders: Ajavahti/, Iniwriter/, xpasso/"
    exit 1
fi

# 1. Copy binary files to /usr/bin
echo "📁 Copying binaries to /usr/bin..."

cd Ajavahti && sudo cp -v ./ajavahti /usr/bin || { echo "❌ Failed to copy ajavahti"; exit 1; }
cd ../Iniwriter && sudo cp -v ./iniwriter /usr/bin || { echo "❌ Failed to copy iniwriter"; exit 1; }
cd ../xpasso && sudo cp -v ./xpasso /usr/bin || { echo "❌ Failed to copy xpasso"; exit 1; }
cd ..

# 2. Ask for RAM disk size
read -p "💾 Enter RAM disk size (e.g. 512M, default: 512M): " RAMDISK_SIZE
RAMDISK_SIZE=${RAMDISK_SIZE:-512M}

# 3. Create the startup script
STARTUP_SCRIPT="/usr/bin/mxlinkxp.sh"
RAMDISK_DIR="\$HOME/ramdisk"

echo "📝 Creating startup script at $STARTUP_SCRIPT..."

sudo tee "$STARTUP_SCRIPT" > /dev/null <<EOF
#!/bin/bash
# MX·Link·XP startup script

# Create the ramdisk directory in the user's home directory
mkdir -p $RAMDISK_DIR

# Mount a tmpfs RAM disk with the specified size
sudo mount -t tmpfs -o size=$RAMDISK_SIZE tmpfs \$HOME/ramdisk

# Start ajavahti in the background
/usr/bin/ajavahti \$HOME/ramdisk &

# Keep the script alive to prevent background process from stopping
echo "MX·Link·XP background service is running. Press Ctrl+C to stop."
while true; do sleep 3600; done
EOF

# 4. Make the script executable
sudo chmod +x "$STARTUP_SCRIPT"

# 5. Final info
echo
echo "✅ Installation complete!"
echo "➡️  Run the startup script with: mxlinkxp.sh"
echo "➡️  This mounts the RAM disk and launches the ajavahti service."
echo
