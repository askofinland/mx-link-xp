# Changes in Version 1.04 – MX·Link·XP

This version introduces new tools and improvements for stability, compatibility, and usability. Below is a summary of the new features and modified components.

---

## ✅ New Features

### 1. Menumaker_for_XP

A GTK3-based graphical Linux application that allows you to select `.desktop` files and generate Windows XP-compatible EXE launchers.

- Preview icons  
- Test program launchability  
- Generate ready-to-compile OpenWatcom project files for XP  
- Projects are stored in:  
  `/home/<user>/MXP/xpstart/<program>/`

### 2. Updated Printing System

- **CutePDF has been removed**
- On the XP side, the setup installs:
  - HP Color LaserJet PS driver
  - RedMon port (RPT1:) redirected to `<drive_letter>:\MXP\Printteri\Tulosta.exe`
- `Tulosta.exe` writes a request file to the RAM disk
- Linux daemon `ajavahti` detects the request and prints it using the default printer

### 3. `setup/linux.log`

- Created by `install.sh` on the Linux side
- Logs installation results of each component: `OK` / `FAIL`
- The XP installer reads this log and installs components conditionally

### 4. Theme Installation Script

- **theme_installer.sh** optionally installs:
  - Windows 10 icon and UI theme
  - Windows XP (Luna) style theme for XFCE

### 5. Antijumi (optional)

- Separate Linux program written in C
- Monitors loop delays to detect sluggishness
- Automatically terminates heavy processes (browsers, Thunderbird, wineserver) when thresholds are exceeded
- Not installed automatically – has its own `install.sh` and `README`
- Located in: `Utils/Antijumi/`

---

## ✏️ Modified Features

### 1. Linux `install.sh`

- Updated to match new folder structure
- Generates `setup/linux.log`
- Asks whether to install MenuMaker
- Asks whether to install themes

### 2. XP Installer

- Reads the `setup/linux.log` file
- Installs OpenWatcom only if `MenuMaker_for_XP OK` is found
- Copies `linsrarter.exe` to `C:\Windows`
- Other programs and registry settings updated accordingly
