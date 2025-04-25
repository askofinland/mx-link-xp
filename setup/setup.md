# MX·Link·XP - Complete Installation Guide

This guide explains how to set up **MX·Link·XP**, which integrates a Windows XP virtual machine with your Linux desktop, enabling full redirection of file types, browser links, and email actions from XP to Linux.

---

## ✅ Step 1: Download and Extract

Download the installation package `mx-link-xp-1.0.zip` from GitHub Releases.

Unzip it and rename the folder from `mx-link-xp-1.0` to `MXP`, then move it to `/home/user/`.

```bash
unzip ~/Downloads/mx-link-xp-1.0.zip
mv mx-link-xp-1.0 MXP
mv MXP ~/  # Now full path is /home/user/MXP

> **Important:** Do **not change** the folder names or paths. All applications and scripts expect the directory to be exactly `/home/user/MXP/`.
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

Navigate to the MX·Link·XP setup folder and run the installer script:

```bash
cd ~/MXP/setup
chmod +x install.sh
./install.sh
```

You will be asked to enter the **RAM disk size** (default: `512M`).

The script performs the following actions:

- Copies the required binaries:
  - `ajavahti`, `iniwriter`, and `xpasso` → `/usr/bin`
- Creates a startup script:  
  `/usr/bin/mxlinkxp.sh`
- The startup script:
  - Mounts a `tmpfs` RAM disk to `~/ramdisk`
  - Starts `ajavahti` in the background
  - Stays alive with an infinite sleep loop

You can test the script immediately:

```bash
mxlinkxp.sh
```

To have it launch automatically at login:

🧰 Optional: Use Stacer for autostart  
If you prefer a graphical tool:

```bash
sudo apt install stacer
```

1. Launch **Stacer**  
2. Go to the **Startup Apps** tab  
3. Add the following command:

```
sudo /usr/bin/mxlinkxp.sh
```

> 💡 Note: Since the script mounts a filesystem, it must be run with `sudo`.

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
