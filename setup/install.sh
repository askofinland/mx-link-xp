#!/bin/bash
echo "=== MX·Link·XP 1.04 Installer ==="

# Estetään sudona ajo
if [ "$EUID" -eq 0 ]; then
  echo "⚠️  Do NOT run this script with sudo!"
  echo "   Run as normal user to detect Desktop and home paths correctly."
  exit 1
fi
# 0. Yhdistetään Watcom-asennuspalat, jos löytyvät
BASE_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PARTS_PATH="$BASE_DIR/Utils/open-watcom.part.*"
TARGET_FILE="$BASE_DIR/Utils/open-watcom-2_0-c-win-x86.exe"

if ls $PARTS_PATH 1> /dev/null 2>&1; then
  echo "🛠️  Watcom installer parts found. Merging into one file..."
  echo "⏳ Please wait a moment – this might take a while. Don’t panic, we’ve got this! 😄"
  cat $PARTS_PATH > "$TARGET_FILE"
  echo "✅ Watcom ready: $(basename "$TARGET_FILE")"
fi

# Nollataan asennusloki
> setup/linux.log

# 1. Varmistetaan että vaaditut binäärit ovat olemassa
REQUIRED_BINS=(
  "Ajavahti/ajavahti"
  "xpasso/xpasso"
  "Iniwriter/iniwriter"
  "setup/XPserver"
)

for bin in "${REQUIRED_BINS[@]}"; do
  if [ ! -f "$bin" ]; then
    echo "❌ Missing required file: $bin"
    echo "$(basename "$bin") FAIL" >> setup/linux.log
    exit 1
  fi
done

# 2. Kysy RAM-levyn koko
read -p "Enter RAM disk size (default: 512M): " RAMSIZE
RAMSIZE=${RAMSIZE:-512M}

# 3. Selvitä lokalisoitu Desktop-kansio
DESKTOP_DIR=$(xdg-user-dir DESKTOP)
shopt -s nocaseglob
DESKTOP_FILE=$(find "$DESKTOP_DIR" -iname "*xp*.desktop" | head -n1)
shopt -u nocaseglob

if [ ! -f "$DESKTOP_FILE" ]; then
  echo "❌ XP .desktop file not found in $DESKTOP_DIR"
  echo "➡️  Please create a VirtualBox or VMware shortcut on your Desktop (e.g. xp.desktop)"
  exit 1
fi

# 4. Poimi Exec-rivi
XP_CMD=$(grep '^Exec=' "$DESKTOP_FILE" | cut -d= -f2-)
if [ -z "$XP_CMD" ]; then
  echo "❌ No Exec= line found in $DESKTOP_FILE"
  exit 1
fi

# 5. Asenna ytimen binäärit ja kirjaa lokiin
echo "📁 Installing core binaries to /usr/bin..."

if sudo install -m 755 Ajavahti/ajavahti /usr/bin/; then
    echo "Ajavahti OK" >> setup/linux.log
else
    echo "Ajavahti FAIL" >> setup/linux.log
fi

if sudo install -m 755 xpasso/xpasso /usr/bin/; then
    echo "xpasso OK" >> setup/linux.log
else
    echo "xpasso FAIL" >> setup/linux.log
fi

if sudo install -m 755 Iniwriter/iniwriter /usr/bin/; then
    echo "iniwriter OK" >> setup/linux.log
else
    echo "iniwriter FAIL" >> setup/linux.log
fi

if sudo install -m 755 setup/XPserver /usr/bin/; then
    echo "XPserver OK" >> setup/linux.log
else
    echo "XPserver FAIL" >> setup/linux.log
fi

# 6. Kysy MenuMakerin asennuksesta ja kirjaa lokiin
read -p "Install MenuMaker_for_XP tool? [y/N]: " install_menu
if [[ "$install_menu" =~ ^[Yy]$ ]]; then
  if [ -f Utils/MenuMaker_for_XP/menumaker ]; then
    if sudo install -m 755 Utils/MenuMaker_for_XP/menumaker /usr/bin/; then
      echo "MenuMaker_for_XP OK" >> setup/linux.log
      echo "✅ menumaker installed to /usr/bin"
    else
      echo "MenuMaker_for_XP FAIL" >> setup/linux.log
      echo "❌ Failed to install menumaker"
    fi
  else
    echo "MenuMaker_for_XP FAIL" >> setup/linux.log
    echo "⚠️ MenuMaker binary not found!"
  fi
fi

# 7. XFCE-ulkoasuteemat
read -p "Install XFCE appearance packages (Windows 10 / XP look)? [y/N]: " install_theme
if [[ "$install_theme" =~ ^[Yy]$ ]]; then
  sudo dpkg -i Utils/windows-10-tp_0.9-6.*.deb 2>/dev/null
  mkdir -p "$HOME/.themes"
  tar -xzf Utils/Windows_XP_Luna.tar.gz -C "$HOME/.themes"
  echo "XFCE_Themes OK" >> setup/linux.log
fi

# 8. Varmista RAM-disk
mkdir -p "$HOME/ramdisk"

# 9. Luo xp-komentoskripti
echo "📝 Creating /usr/bin/xp startup launcher..."
sudo tee /usr/bin/xp > /dev/null <<EOF
#!/bin/bash
RAMDISK="\$HOME/ramdisk"
if ! mountpoint -q "\$RAMDISK"; then
  sudo mount -t tmpfs -o size=$RAMSIZE myramdisk "\$RAMDISK" || { echo "❌ Failed to mount RAM disk."; exit 1; }
fi
/usr/bin/ajavahti "\$RAMDISK" &
$XP_CMD
sudo umount "\$RAMDISK"
EOF
sudo chmod +x /usr/bin/xp

#  Kysy, haluaako käyttäjä ajaa teemojen asentajan
read -p "🎨 Do you want to run the theme installer script now? (y/n): " run_theme_installer
if [[ "$run_theme_installer" =~ ^[Yy]$ ]]; then
    if [ -f Utils/theme_installer.sh ]; then
        bash Utils/theme_installer.sh
    else
        echo "❌ theme_installer.sh not found in Utils/"
    fi
fi


# 10. Päivitä .desktop tiedosto
echo "🛠 Updating Desktop shortcut to use new launcher..."
sed -i "s|^Exec=.*|Exec=xfce4-terminal --working-directory=$HOME -e xp|" "$DESKTOP_FILE"
echo "✅ Desktop shortcut updated."

# 11. Valmis
echo
echo "✅ Installation complete!"
echo "➡️  Launch XP with the command: xp"


