#!/bin/bash
echo "=== MX·Link·XP Theme Installer ==="

# Estetään sudona ajo
if [ "$EUID" -eq 0 ]; then
  echo "⚠️  Do NOT run this script with sudo!"
  exit 1
fi

echo
read -p "📦 Install Windows 10 icon theme? (y/n): " install_win10
read -p "🎨 Install Luna (XP) appearance theme? (y/n): " install_luna

# Asennetaan Win10-kuvaketeema
if [[ "$install_win10" =~ ^[Yy]$ ]]; then
  if [ -f windows-10-tp_0.9-6.i386.deb ]; then
    echo "📁 Installing Win10 icon theme..."
    sudo dpkg -i windows-10-tp_0.9-6.i386.deb || {
      echo "❌ dpkg failed. Trying to fix dependencies..."
      sudo apt-get install -f
    }
    echo "✅ Win10 icon theme installed."
  else
    echo "❌ windows-10-tp_0.9-6.i386.deb not found!"
  fi
fi

# Asennetaan Luna-ulkoasu
if [[ "$install_luna" =~ ^[Yy]$ ]]; then
  if [ -f Windows_XP_Luna.tar.gz ]; then
    echo "📁 Installing Luna theme..."
    mkdir -p ~/.themes
    tar -xzf Windows_XP_Luna.tar.gz -C ~/.themes
    echo "✅ Luna theme extracted to ~/.themes"
  else
    echo "❌ Windows_XP_Luna.tar.gz not found!"
  fi
fi

echo
echo "🎉 Done! You can now activate themes via Appearance and Icons settings."
