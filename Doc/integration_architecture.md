# 🔗 MX·Link·XP – Integration Architecture

This document explains the architecture of **MX·Link·XP**, focusing on how the Linux and Windows XP systems interact and how tasks are delegated between them for maximum efficiency and stability.

---

## 🧠 Core Design Philosophy

MX·Link·XP is not just an installer — it's a **bidirectional integration layer** between a modern Linux desktop and a legacy Windows XP environment. It allows the user to **run tasks where they perform best**:

- Legacy Win32 applications → XP (e.g., Winamp, Excel 2003)
- Browsing, printing, file management → Linux

The integration is designed to be:
- ⚡ **Fast**: Minimal latency in execution
- 💾 **Lightweight**: Runs on low-end hardware
- 🔐 **Safe**: XP is offline-only, without any networking enabled

---

## 🗂️ File Exchange

All data exchange occurs via a shared RAM disk mounted as:

- **Linux**: `/home/user/ramdisk/`
- **Windows XP**: `Z:\ramdisk\`

Windows XP sees the Linux home directory as a mapped drive (e.g., `Z:\`),  
**where `Z:` is the default assigned by VirtualBox** — but it may be different on your system.  
You can confirm the correct drive letter inside XP's Explorer under “My Computer”.

The **`aja.ini`** file inside this disk acts as the **central communication channel** between systems.

---

## 🔄 Communication Flow

### 1. XP → Linux

XP applications (like file shortcuts or PDF printer) write structured commands into `Z:\ramdisk\aja.ini`.

Linux reads `aja.ini` and acts accordingly:

- Launch Linux applications
- Print PDFs via native `lp` system
- Raise windows (`wmctrl -a`)

Linux then clears the `start=true` flag to signal completion.

### 2. Linux → XP

Linux programs (like `xpasso`) can write XP-related instructions into `aja.ini`, such as launching `.exe` binaries on XP. The running `xpserv.exe` detects changes and launches the requested program.

---

## 🧩 Components by Role

| Role                    | Component             | Platform |
|-------------------------|-----------------------|----------|
| Central dispatcher      | `ajavahti`            | Linux    |
| INI updater             | `iniwriter`           | Linux    |
| XP launcher interface   | `xpasso`              | Linux    |
| INI monitor             | `xpserv.exe`          | Windows XP |
| Shortcut creator        | `Desktop maker.exe`   | Windows XP |
| XP installer            | `setup1.exe`          | Windows XP |
| Startup binder          | `install.sh`          | Linux    |

---

## 🖥️ Filesystem Integration

Windows XP accesses Linux's `/home/user` as drive **Z:\\** via VirtualBox Shared Folders.  
This includes the RAM disk path: `Z:\ramdisk\`.

- File opens, saves, and references work seamlessly across systems

---

## 🖨️ Printing Architecture

- PDF print jobs from XP (CuteWriter) are directed to `Z:\ramdisk\`
- Linux `ajavahti` daemon detects `.pdf` files
- Sends them to `lp` for native printing
- Deletes the file once successfully printed

---

## 🔐 Security Architecture

- **XP is fully offline**
  - Network card is disconnected
  - All network-related services are disabled
- **System integrity**
  - No registry cleaners or service installers
  - Minimalist install = maximal reliability
- **Snapshots**
  - Use VirtualBox snapshots to restore system state instantly

---

## 📌 Summary

MX·Link·XP connects a lightweight, secure XP environment with the power of Linux through a **RAM-based message queue** (`aja.ini`), shared folders, and minimal background services.

> 🧠 Efficiency by design: XP is stable, fast, and limited to what it does best —  
> Linux handles everything modern and secure.
