#!/bin/bash
echo "=== MenuMaker Installer ==="

# Estetään sudona ajo
if [ "$EUID" -eq 0 ]; then
  echo "⚠️  Do NOT run this script with sudo!"
  echo "   Run as a normal user."
  exit 1
fi

# Varmistetaan että lähdekoodi löytyy
if [ ! -f menumaker.c ]; then
    echo "❌ menumaker.c not found in current directory!"
    exit 1
fi

# Käännetään ohjelma
echo "🔧 Compiling menumaker..."
gcc menumaker.c -o menumaker `pkg-config --cflags --libs gtk+-3.0 gdk-pixbuf-2.0`
if [ $? -ne 0 ]; then
    echo "❌ Compilation failed!"
    exit 1
fi

# Asennetaan /usr/bin hakemistoon
echo "📁 Installing to /usr/bin/..."
sudo install -m 755 menumaker /usr/bin/menumaker
if [ $? -ne 0 ]; then
    echo "❌ Installation failed!"
    exit 1
fi

echo "✅ menumaker installed successfully!"
echo "➡️  You can now run it with the command: menumaker"
