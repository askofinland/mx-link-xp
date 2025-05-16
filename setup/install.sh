#!/bin/bash
echo "=== MX·Link·XP Installer ==="

# Estetään sudona ajo
if [ "$EUID" -eq 0 ]; then
  echo "⚠️  Do NOT run this script with sudo!"
  echo "   It must be run as a normal user so we can detect your Desktop folder correctly."
  exit 1
fi

# 1. Varmistetaan, että tarvittavat tiedostot löytyvät
if [ ! -f Ajavahti/ajavahti ] || [ ! -f xpasso/xpasso ] || [ ! -f Iniwriter/iniwriter ]; then
    echo "❌ Required binaries not found in project directories!"
    echo "   Make sure you run this from the MX-Link-XP project root."
    exit 1
fi

# 2. Kysy RAM-levyn koko
read -p "Enter RAM disk size (default: 512M): " RAMSIZE
RAMSIZE=${RAMSIZE:-512M}

# 3. Etsi XP .desktop tiedosto
DESKTOP_FILE=$(ls "$HOME"/Desktop/XP*.desktop 2>/dev/null | head -n1)

# Selvitetään lokalisoitu Desktop-kansio
DESKTOP_DIR=$(xdg-user-dir DESKTOP)

# Sallitaan kirjainkoon huomiotta jättäminen
shopt -s nocaseglob
DESKTOP_FILE=$(ls "$DESKTOP_DIR"/xp*.desktop 2>/dev/null | head -n1)
shopt -u nocaseglob

if [ ! -f "$DESKTOP_FILE" ]; then
    echo "❌ XP .desktop file not found in Desktop folder: $DESKTOP_DIR"
    echo "➡️  Please create a VirtualBox or VMware shortcut on your Desktop (e.g. xp.desktop)"
    exit 1
fi

# 4. Poimi Exec-rivi ja tallenna XP_CMD-muuttujaan
XP_CMD=$(grep '^Exec=' "$DESKTOP_FILE" | cut -d= -f2-)

if [ -z "$XP_CMD" ]; then
    echo "❌ No Exec= line found in $DESKTOP_FILE"
    exit 1
fi

# 5. Kopioidaan binäärit /usr/bin
echo "📁 Copying binaries to /usr/bin..."
sudo install -m 755 Ajavahti/ajavahti /usr/bin/ || { echo "❌ Failed to install ajavahti"; exit 1; }
sudo install -m 755 xpasso/xpasso /usr/bin/ || { echo "❌ Failed to install xpasso"; exit 1; }
sudo install -m 755 Iniwriter/iniwriter /usr/bin/ || { echo "❌ Failed to install iniwriter"; exit 1; }
echo "✅ Binaries installed successfully."

# 5b. Asennetaan XPserver-skripti
if [ -f setup/XPserver ]; then
    echo "📁 Installing XPserver to /usr/bin..."
    sudo install -m 755 setup/XPserver /usr/bin/ || { echo "❌ Failed to install XPserver"; exit 1; }
    echo "✅ XPserver script installed."
else
    echo "⚠️  XPserver script not found at setup/XPserver – skipping."
fi

# 6. Varmistetaan ramdisk-hakemisto
mkdir -p "$HOME/ramdisk"

# 7. Luodaan /usr/bin/xp -käynnistysskripti
echo "📝 Creating /usr/bin/xp launcher script..."

sudo tee /usr/bin/xp > /dev/null <<EOF
#!/bin/bash
# MX·Link·XP startup script

RAMDISK="\$HOME/ramdisk"

# Mount RAM disk if not already mounted
if ! mountpoint -q "\$RAMDISK"; then
    sudo mount -t tmpfs -o size=$RAMSIZE myramdisk "\$RAMDISK" || { echo "❌ Failed to mount RAM disk."; exit 1; }
fi

# Start ajavahti in background
/usr/bin/ajavahti "\$RAMDISK" &

# Launch XP
$XP_CMD

# XP has exited – cleanup
sudo umount "\$RAMDISK"
EOF

# 8. Tehdään skriptistä ajettava
sudo chmod +x /usr/bin/xp

# 9. Päivitetään .desktop tiedosto
echo "🛠 Updating .desktop file to use 'Exec=xp'..."
sed -i 's|^Exec=.*|Exec=xfce4-terminal --working-directory=$HOME -e xp|' "$DESKTOP_FILE"
echo "✅ Desktop shortcut updated: $DESKTOP_FILE"

# 10. Valmis
echo
echo "✅ Installation complete!"
echo "➡️  You can now run MX·Link·XP with the command: xp"
echo "📌 Your XP Desktop shortcut now uses the new xp launcher."
