# MX·Link·XP - Complete Installation Guide

This guide explains how to set up **MX·Link·XP**, which integrates a Windows XP virtual machine with your Linux desktop, enabling full redirection of file types, browser links, and email actions from XP to Linux.

---

## ✅ Step 1: Download and Extract

Download the installation package `mx-link-xp-1.x.zip` from GitHub Releases.

Unzip it and rename the folder to `MXP`, then move it to `/home/user/`.

```bash
unzip ~/Downloads/mx-link-xp-1.*.zip
mv mx-link-xp-1.* MXP
mv MXP ~/  # Now full path is /home/user/MXP

> **Important:** Do **not change** the folder names or paths. All applications and scripts expect the directory to be exactly `/home/user/MXP/`.
```

---

## 🛠️ Step 2: Install VirtualBox on Linux

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
   * Name: `Windows XP`
   * Type: Microsoft Windows
   * Version: Windows XP (32-bit)
3. Allocate memory (recommended: 1024 MB).
4. Create a new virtual hard disk (VDI, dynamically allocated, 50 GB).

Install Windows XP as usual using an ISO image or physical disc.

---

## ⚙️ Step 4: Configure VirtualBox Settings

### 🕉 Install Guest Additions:

1. Start the XP guest.
2. From the VirtualBox menu:
   `Devices` → `Insert Guest Additions CD image…`
3. Run `VBoxWindowsAdditions.exe` inside XP and reboot when done.

### 🕿 Enable USB support:

```bash
sudo usermod -aG vboxusers $USER
```

> **Log out and back in** for group changes to take effect.

### 📁 Shared Folder Setup:

1. In VirtualBox settings for XP:
   * Go to **Shared Folders**.
   * Click **+** to add a folder.
2. **Folder Path:** `/home/user`
3. **Folder Name:** `user`
4. ✅ Enable `Auto-mount`
5. ✅ Enable `Make Permanent`

Inside XP, this folder appears as:

```
Z:\  =  /home/user
```

> **Note:** The drive letter (e.g. `Z:\`) may vary depending on your system configuration.  
> This shared folder is required for MX·Link·XP to function properly.

---

## 🐧 Step 5: Install Linux-side Components

Navigate to the MX·Link·XP setup folder and run the installer script **as a normal user** (not with `sudo`):

```bash
cd ~/MXP/
chmod +x ~/MXP/setup/install.sh
~/MXP/setup/install.sh
```

> ⚠️ **Do not run this script with `sudo`!**  
> It must be run as your normal Linux user so the correct Desktop folder (e.g., `~/Työpöytä` or `~/Desktop`) can be detected properly.

You will be asked to enter the **RAM disk size** (default: `512M`).

The script performs the following actions:

* Verifies that all required binaries exist
* Copies the binaries `ajavahti`, `iniwriter`, and `xpasso` to `/usr/bin`
* Installs a helper script `/usr/bin/XPserver` that prints a welcome message on first run
* Detects your XP virtual machine's `.desktop` launcher (e.g. `xp.desktop`)
* Extracts the actual VirtualBox launch command from it
* Creates a new system-wide launcher script:  
  `/usr/bin/xp`

The new `xp` launcher:

1. Mounts `~/ramdisk` as a tmpfs RAM disk
2. Starts `ajavahti` in the background using that RAM disk
3. Launches your XP virtual machine
4. Unmounts the RAM disk after XP shuts down

It also modifies the original `.desktop` shortcut on your desktop to use:

```ini
Exec=xfce4-terminal --working-directory=$HOME -e xp
```

So you can simply launch XP from the icon or by typing `xp` in a terminal.

---

## 🪠 Step 6: Install XP-side Software

1. In the XP virtual machine, open:

```
Z:\MXP\setup
```

> **Note:** The drive letter (e.g. `Z:\`) may vary depending on your system configuration.

2. Run:

```
setupXP.exe
```

This launches the **MX·Link·XP Setup** graphical installer.

---

### ✅ Features of the installer:

- Modern visual layout with themed colors and font  
- Detects the correct installation path automatically  
- Allows selective installation of:
  - **Firefox**
  - **Thunderbird**
  - **MXlinkXP Media Player** (media file handler)
  - **Google Chrome Dock shortcut**
  - **MX File Manager shortcut**
  - **Linux Terminal shortcut**
  - **Chromium Dock launcher**
  - **CuteWriter PDF printer**
  - **Calendar Utility** installed to XP's Startup folder  
- Installs:
  - XP communication daemon (`xpserv.exe`) to Startup folder  
  - File type handlers (e.g., media files with MXlinkXP Media Player)  
  - Utility apps like **Desktop Maker**  
- Registers OCX component (`COMDLG32.OCX`) if not already present  
- After installation, you are asked whether to run **Desktop Maker**  
  → This allows you to create a Linux desktop shortcut for it immediately

---

### 💡 Installer Tips:

- **Install Firefox and Thunderbird manually first** using the buttons at the top of the GUI  
- When ready, click **"Install Server and Utilities"** to apply all selected components  
- After installation, you’ll see the confirmation:
  ```
  Setup Complete – Server and utilities installed.
  ```

---

### 🔁 Final Step: Restart XP

> **Reboot Windows XP after the installer finishes.**  
> This ensures that `xpserv.exe`, **MXlinkXP Media Player**, and the optional **Calendar Utility** will start automatically with XP.

---

## ✅ Summary

| Step   | Description                                    |
|--------|------------------------------------------------|
| Step 1 | Extract `MXP.zip` to `/home/user/MXP`          |
| Step 2 | Install VirtualBox on Linux                    |
| Step 3 | Create Windows XP guest                        |
| Step 4 | Configure USB, Guest Additions, Shared Folder  |
| Step 5 | Run Linux installer `install.sh`               |
| Step 6 | Run XP installer `setupXP.exe` via shared folder |

---

## ℹ️ After Installation

- All browser clicks and email actions in XP are redirected to Linux  
- `xpserv.exe` runs in the background on XP startup  
- `/usr/bin/XPserver` prints a welcome message during the first Linux trigger  
- `xdg-open.exe` handles link and file redirection to Linux  
- Use **Desktop Maker** to generate additional custom shortcuts later  
- Optional calendar tool launches at XP startup if selected

🎉 Enjoy seamless Linux–XP integration with **MX·Link·XP**!
