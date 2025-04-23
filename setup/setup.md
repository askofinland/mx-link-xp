# MX·Link·XP - Complete Installation Guide

This guide explains how to set up **MX·Link·XP**, which integrates a Windows XP virtual machine with your Linux desktop, enabling full redirection of file types, browser links, and email actions from XP to Linux.

---

## ✅ Step 1: Download and Extract

Download the installation package `MXP.zip` and extract it to:

```
/home/user/MXP/
```

> **Important:** Do **not change** the folder names or paths. All applications and scripts expect the directory to be exactly `/home/user/MXP/`.

### 📦 Example (Terminal):

```bash
cd ~
mkdir -p ~/MXP
unzip -o ~/Downloads/MXP.zip -d ~/MXP
```

---

## 🧰 Step 2: Install VirtualBox on Linux

### Debian / Ubuntu / MX Linux:

```bash
sudo apt update
sudo apt install virtualbox virtualbox-ext-pack
```

### Arch / Manjaro:

```bash
sudo pacman -S virtualbox virtualbox-ext-vnc
```

---

## 🖥️ Step 3: Create a Windows XP Guest Machine

1. Open **VirtualBox**.
2. Create a new virtual machine:
   - Name: `Windows XP`
   - Type: Microsoft Windows
   - Version: Windows XP (32-bit)
3. Allocate memory (recommended: 512–1024 MB).
4. Create a new virtual hard disk (VDI, dynamically allocated, 10–20 GB).

Install Windows XP as usual using an ISO image or physical disc.

---

## ⚙️ Step 4: Configure VirtualBox Settings

### 🧩 Install Guest Additions:

1. Start the XP guest.
2. From the VirtualBox menu:  
   `Devices` → `Insert Guest Additions CD image…`
3. Run `VBoxWindowsAdditions.exe` inside XP and reboot when done.

### 🧷 Enable USB support:

```bash
sudo usermod -aG vboxusers $USER
```

> **Log out and back in** for group changes to take effect.

### 📁 Shared Folder Setup:

1. In VirtualBox settings for XP:
   - Go to **Shared Folders**.
   - Click **+** to add a folder.
2. **Folder Path:** `/home/user`
3. **Folder Name:** `user`
4. ✅ Enable `Auto-mount`
5. ✅ Enable `Make Permanent`

Inside XP, this folder appears as:

```
Z:\  =  /home/user
```

> This is required for MX·Link·XP to function properly.

---

## 🐧 Step 5: Install Linux-side Components

Navigate to the MX·Link·XP folder and run:

```bash
cd ~/MXP
chmod +x install.sh
./install.sh
```

You will be asked to enter the RAM disk size (default: **512M**).  
This creates `~/ramdisk` and configures:

- `ajavahti` daemon (starts on boot)
- `iniwriter` and `xpasso`
- system integration
- boot-time setup

Afterward:

```bash
sudo reboot
```

---

## 🪟 Step 6: Install XP-side Software

1. In the XP virtual machine, browse to `Z:\MXP\setup`
2. Run `setup.exe`. This prepares DLLs and launches the GUI installer.
3. Select the applications you want to install.
4. Follow the prompts:
   - Firefox and Thunderbird are installed and set as default apps.
   - Do **not** create a mail account in Thunderbird — just set as default and close.
   - CuteWriter will prompt separately.
   - Desktop Maker runs at the end and lets you create its own shortcut.

---

## ✅ Summary

| Step                | Description                                      |
|---------------------|--------------------------------------------------|
| Step 1              | Extract `MXP.zip` to `/home/user/MXP`            |
| Step 2              | Install VirtualBox on Linux                      |
| Step 3              | Create Windows XP guest                          |
| Step 4              | Configure USB, Guest Additions, Shared Folder    |
| Step 5              | Run Linux installer `install.sh`                 |
| Step 6              | Run XP installer `setup.exe` via shared folder   |

---

## ℹ️ After Installation

- All browser clicks and email actions in XP are redirected to Linux.
- `xpserv` runs in the background.
- `xdg-open.exe` handles link redirection.
- Use Desktop Maker to generate custom shortcuts later.

Enjoy seamless Linux–XP integration with **MX·Link·XP**! 🎉
