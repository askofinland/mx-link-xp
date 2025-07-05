#!/bin/bash
echo "=== Antijumi Installer ==="

# Estetään sudona ajo
if [ "$EUID" -eq 0 ]; then
  echo "⚠️  Do NOT run this script with sudo!"
  echo "   Run as a normal user."
  exit 1
fi

# Varmistetaan että lähdekoodi löytyy
if [ ! -f antijumi.c ]; then
    echo "❌ antijumi.c not found in current directory!"
    exit 1
fi

# Käännetään ohjelma
echo "🔧 Compiling antijumi..."
gcc antijumi.c -o antijumi
if [ $? -ne 0 ]; then
    echo "❌ Compilation failed!"
    exit 1
fi

# Asennetaan /usr/bin hakemistoon
echo "📁 Installing to /usr/bin/..."
sudo install -m 755 antijumi /usr/bin/antijumi
if [ $? -ne 0 ]; then
    echo "❌ Installation failed!"
    exit 1
fi

echo "✅ antijumi installed successfully!"
echo "➡️  You can now run it with the command: antijumi 30"
