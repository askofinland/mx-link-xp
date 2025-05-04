# 🛠️ Developer Overview – MX·Link·XP

This document provides an overview of the source code and compiled components in the MX·Link·XP project.

---

## 🔧 Languages Used

| Language | Purpose                          |
|----------|----------------------------------|
| C        | Linux-side daemons and XP-side console tools |
| VB6      | Windows XP GUI applications      |

All components include both **source code** and **precompiled binaries** in their respective directories.

---

## 📁 Directory Overview

| Directory     | Platform | Language | Description |
|---------------|----------|----------|-------------|
| `Ajavahti/`   | Linux    | C        | Main communication daemon. Watches `aja.ini` and `.pdf` files and launches Linux-side commands. |
| `Iniwriter/`  | Linux    | C        | Command-line tool to modify `aja.ini` values in a safe and scriptable way. |
| `xpasso/`     | Linux    | C        | Injects Linux-to-XP execution requests into `aja.ini`. |
| `xpserv/`     | XP       | VB6      | Resident XP-side background app. Reads `aja.ini` and executes Windows-side actions requested by Linux. Also writes `[XP] ROOT=` path. |
| `linstart/`   | XP       | C        | Lightweight XP console tool that writes Linux-side commands into `aja.ini`. Used by VB6 launchers. |
| `Utils/calendar/` | XP   | C        | Adds a calendar popup to the XP system tray, imitating LXDE clock behavior. Includes full tray icon and UI logic. |
| `setup/`      | XP       | VB6 + Bash | Contains `setup1.exe` (VB6) and `install.sh` (Linux). Prepares the environment. |
| `Thunar/`     | XP       | VB6      | File manager shortcut (launches `/usr/bin/thunar` via `linstart`). |
| `terminaali/` | XP       | VB6      | Opens LXTerminal or similar shell through Linux. |
| `Firefox/`    | XP       | VB6      | Firefox Linux-side launcher and default browser setter for XP. |
| `thunderbird/`| XP       | VB6      | Thunderbird launcher, works similarly to Firefox entry. |
| `GoogleChrome/`| XP     | VB6      | Chrome-specific launcher (optional). |
| `Cromium/`    | XP       | VB6      | Chromium shortcut for XP panel or desktop. |
| `vlc/`        | XP       | VB6      | Video/audio file association handler for VLC. |
| `xdg-open/`   | XP       | VB6      | Redirects XP file open requests to Linux. |
| `Utils/Desktop maker/` | XP | VB6 | Tool to build .lnk launchers from ini-configured logic. |
| `Utils/`      | XP       | Mixed    | Contains additional tools: CuteWriter installer, shared OCX controls. |

---

## 🔍 Notable Components

### 🖥️ `linstart.exe` (XP, C)

- A command-line program used by VB6 launchers.
- Finds the correct drive where `\MXP\` resides.
- Writes a Linux execution request into `Z:\ramdisk\aja.ini`.
- Simple, fast, and compatible with all XP configurations.

### 🕑 `calendar.exe` (XP, C)

- Mimics LXDE's calendar popup behavior in the XP system tray.
- Uses `MONTHCAL_CLASS` from Windows Common Controls.
- Starts hidden, responds to tray icon clicks.
- Ideal for minimal desktop setups.

---

## 📄 Additional Notes

- All compiled executables are included with their full source.
- C programs use Win32 or POSIX APIs with minimal dependencies.
- VB6 programs target native XP systems — **no Wine required or supported**.
- File paths and drive assumptions are baked into launch logic. Do **not rename folders**.

---

## 📁 Filesystem Mapping

| Linux Path             | XP Equivalent         | Notes                          |
|------------------------|------------------------|--------------------------------|
| `/home/user/`          | `Z:\`                  | Main mount point               |
| `/home/user/MXP/`      | `Z:\MXP\`              | System files and launchers     |
| `/home/user/ramdisk/`  | `Z:\ramdisk\`          | Runtime communication files    |

---

## 📷 Visual Aid

- Logo file `Tux walk on the bliss (square).png` represents the spirit of the project — Linux (Tux) walking across Windows XP's iconic landscape.

---

## ✍️ Developer's Statement

> All Windows XP-side applications in this project are written in **Visual Basic 6**.
>
> Why? Because:
>
> - The VB6 IDE is **fast, direct, and stable** — perfect for XP
> - The runtime is **already present** in XP
> - Code is **debuggable, visual, and easy to extend**
>
> That said, if you prefer C or another language — go for it.  
> All core logic is modular and easy to reimplement.

---

## ⚠️ Coding Guidelines

- XP-side code assumes VB6 runtime and Win32 API behavior
- Linux-side code avoids elevated permissions and uses standard C
- Always test path logic and `aja.ini` behavior with realistic setups

---

## 📫 Contributions

You’re welcome to:
- Reimplement any VB6 launcher in C or another language
- Improve the daemon logic on Linux
- Suggest INI schema improvements or add support for async signaling

Just remember:  
**XP compatibility is sacred. Linux compatibility is essential. Wine is irrelevant.**

```bash
git clone [your fork here]
cd MXP
# hack away!
```
