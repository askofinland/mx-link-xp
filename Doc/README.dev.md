# Developer Overview – MX·Link·XP

This document provides an overview of the source code and compiled components in the MX·Link·XP project.

## 🔧 Languages Used

| Language | Purpose                          |
|----------|----------------------------------|
| C        | Linux-side daemons and tools     |
| VB6      | Windows XP GUI applications      |

Both types include **source code** and **precompiled binaries** within each application directory.

---

## 📁 Directory Overview

| Directory     | Platform | Language | Description |
|---------------|----------|----------|-------------|
| `Ajavahti/`   | Linux    | C        | Main communication daemon. Watches `aja.ini` and `.pdf` files. |
| `Iniwriter/`  | Linux    | C        | Updates key-value pairs in `aja.ini`. |
| `xpasso/`     | Linux    | C        | Writes commands to `aja.ini` to be executed on XP. |
| `xpserv/`     | XP       | VB6      | Autostarts with XP. Handles Linux communication. |
| `setup/`      | XP       | VB6 + Bash | Contains `setup1.exe` and `install.sh`. |
| `Thunar/`     | XP       | VB6      | File manager shortcut to Linux's file system. |
| `terminaali/` | XP       | VB6      | Opens Linux terminal from XP. |
| `Firefox/`    | XP       | VB6      | Launches Firefox and sets it as the default browser. |
| `thunderbird/`| XP       | VB6      | Launches Thunderbird and sets it as the default mail client. |
| `GoogleChrome/`| XP     | VB6      | Optional Chrome shortcut to Linux. |
| `Cromium/`    | XP       | VB6      | Chromium taskbar shortcut. |
| `vlc/`        | XP       | VB6      | File association with VLC. |
| `xdg-open/`   | XP       | VB6      | XP side launcher to redirect open actions to Linux. |
| `Utils/Desktop maker/` | XP | VB6 | Tool to create shortcuts on XP desktop. |
| `Utils/`      | XP       | Mixed    | Contains CuteWriter installer and OCX dependencies. |

---

## 📄 Additional Notes

- All compiled executables are included alongside their source code.
- C programs are written for portability and performance on lightweight Linux systems.
- VB6 programs are designed to run under Windows XP only (no Wine compatibility required).
- The root directory contains the image `Tux walk on the bliss (square).png`, which is the project's official logo.

---

## 📚 Where to find more?

Each directory may include a more detailed `README.dev.md` with function-level documentation and build instructions.

```bash
tree -f -I '*.exe|*.ico|*.frx|*.vbw|*.log|*.sym|*.map|*.mk*|*.rc|*.wpj|*.tgt|*.obj|*.PDM'

## ✍️ Developer's Statement

> All Windows XP-side applications in this project are written in **Visual Basic 6**.
>
> The reason is simple:
>
> - The **VB6 IDE is familiar, fast, and highly efficient** for quick development and debugging.
> - It's a practical match for Windows XP, where the VB6 runtime is already present.
> - For this project's scope, **speed of iteration and maintainability** mattered more than modern language trends.
>
> 🛠️ That said, **if someone with strong C skills** wishes to rewrite these in C for performance or portability —  
> the original developer would **gladly welcome it (and cheer quietly from the shadows)**.

---

## 📝 Additional Notes

- All binaries are **self-contained** and expect supporting files to follow the defined directory layout.
- **Do not change the folder names or structure.** They are hardcoded into launch logic.
- The Linux-side `ajavahti` uses `aja.ini` as a central communication channel.
- All paths use `Z:\` on XP to reference `/home/user/` on the Linux side.

---

## 📫 Contributions

Feel free to fork the repository, improve C code, or reimplement XP parts with modern tools — as long as **compatibility with XP and Linux integration remains intact**.

