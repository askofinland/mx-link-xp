# mx-link-xp
Seamless integration of MX Linux and Windows XP using VirtualBox, shared RAM-disk and command file.
# MX·Link·XP – Seamless Integration of MX Linux and Windows XP

**MX·Link·XP** (MXP) connects MX Linux and Windows XP into a single, unified system – without dualboot. XP works as a user interface, while Linux handles the heavy tasks, internet, media, and modern applications.

## 🎯 Who is it for?

- Users familiar with Linux and XP  
- No need for modern Windows versions  
- Want to avoid dualboot  
- Need to run XP applications safely in a virtualized environment

---

## 🔧 Requirements

- **Host OS:** MX Linux (recommended: Xfce)
- **Guest OS:** Windows XP (in VirtualBox)
- **Shared folder between systems:**
  - In Linux: `/home/user/ramdisk`
  - In XP: `E:\home\user\ramdisk`
- **RAM disk:** 64 MB is enough

---

## 📦 Installation Steps

### 1. Extract ZIP archive

Example destination:

```
/home/user/MXP
```

### 2. Install Linux daemon (`ajavahti`)

```bash
cp /home/user/MXP/C/ajavahti.c ~/
gcc -o ajavahti ajavahti.c
./ajavahti /home/user/ramdisk
```

> This background process watches `aja.ini` and executes commands on the Linux side.

### 3. Install Desktop Maker for XP

- Run:
  ```
  /home/user/MXP/Utils/Desktop\ maker/Package/setup.exe
  ```
- Installs to: `C:\Program Files\Desktop maker\`
- Registers: `COMDLG32.OCX`
- Allows creating `.desktop` launchers for Linux desktop

### 4. Install XP daemon (`xpserv.exe`)

Copy:

```
E:\home\user\MXP\xpserv\xpserv.exe → 
C:\Documents and Settings\All Users\Start Menu\Programs\Startup
```

XP will start it automatically on login.

---

### 5. Install association programs

✅ Steps:

1. Install original versions of:
   - Thunderbird (email)
   - VLC (media)
   - Download Firefox 40.0:
  [https://ftp.mozilla.org/pub/firefox/releases/40.0/](https://ftp.mozilla.org/pub/firefox/releases/40.0/)

- Install Firefox normally in XP — this sets it as the XP default web browser.

2. Set them as default programs in XP
3. Replace the installed EXE files with MXP versions:

```
Example:
C:\Program Files\Mozilla Firefox\firefox.exe 
→ E:\home\user\MXP\Firefox\Firefox.exe
```

> These versions don’t run the software in XP — they send commands to Linux via `aja.ini`.

---

### 6. Copy dock programs

Copy to XP Start Menu:

```
E:\home\user\MXP\Thunar\Thunar.exe
E:\home\user\MXP\terminaali\Terminal.exe
E:\home\user\MXP\Cromium\chromium.exe
E:\home\user\MXP\GoogleChrome\googlechrome.exe
```

Destination:

```
C:\Documents and Settings\All Users\Start Menu\Programs\
```

> **Thunderbird** handles `mailto:` and acts as a visible dock icon in XP's panel.

---

### 7. Create launchers for other XP programs

Use **Desktop Maker** to create `.desktop` launchers for other XP apps.

---

### 8. Install `iniwriter` in Linux

```bash
sudo cp /home/user/MXP/Utils/bin/iniwriter /usr/bin/
```

---

## 📂 Directory Structure

`/home/user/MXP` contains:

- `C/` → Linux-side daemon
- `xpserv/` → XP-side daemon
- `Utils/` → `iniwriter`, Desktop Maker
- `Firefox/`, `vlc/`, `Thunar/`, `GoogleChrome/` → Dock programs
- `ramdisk/` → shared folder
- `aja.ini` → command file between systems

> `.desktop` files are **not** stored here — they go on the user's actual Linux desktop.

---

## 🔐 Security

- XP has **no network access** (VirtualBox NIC disabled)
- All web/email/media is handled by Linux
- XP just acts as GUI
- No background or hidden internet connections

---

## ❤️ Copyright and Donations

**MX·Link·XP** is free software developed as a personal hobby.

You are free to use, modify, and redistribute it.

💸 If you find MX·Link·XP useful, consider supporting the project:

**PayPal:** askofinland@live.com

---

## ⚠️ Disclaimer

**MX·Link·XP** is provided *as-is*.  
Use it **at your own risk**.  
The developer is not responsible for any damage to data or systems.

---
