# 📁 MX·Link·XP Directory Structure and Logic

MX·Link·XP is built on a predictable and controlled directory layout that bridges a Linux host and a Windows XP guest through a shared folder. Understanding these locations is essential for both operation and maintenance.

---

## 📂 `/home/user` (Linux side)

This is the **Linux user’s home directory**. It is exported (e.g. via VirtualBox shared folder) to the XP guest system and **appears in XP as a mapped drive**, typically:

```
Z:\
```

However, **the drive letter is not fixed** — the system detects the correct drive by scanning from `A:` to `Z:` for a specific marker folder (`MXP\`).

---

## 📂 `/home/user/MXP` → `Z:\MXP\` (XP sees this)

### ✅ Purpose:
- Main system folder
- Contains all MX·Link·XP binaries, VB6 applications, helper tools, icons, etc.
- Acts as a **marker (flag)**: its presence determines that the user is valid and MX·Link·XP is active on this machine.

### 🔐 Rule:
- **Only one MXP folder is allowed per machine.**
- That means: **only one user account** can be active in the system at once.

This ensures deterministic behavior across all command-line tools (e.g., `linstart`, `xpserv`, `xpasso`) and GUI components.

---

## 📂 `/home/user/ramdisk` → `Z:\ramdisk\` (XP sees this)

### ✅ Purpose:
- **Temporary runtime state folder**
- Contains:
  - `aja.ini` — the central control file for inter-OS communication
  - Possible temporary files during command handling or feedback

This folder is **volatile** — it is cleared on reboot or session change. It must be present and writable by both Linux and XP processes.

---

## 📄 `aja.ini`

Placed inside the **ramdisk**, this file is the **shared state interface** between XP and Linux:

- XP writes to it (e.g., via `linstart.exe`)
- Linux monitors it (via `ajavahti`)
- Only one command can be active at a time (`start=true`)
- Acts as a simple IPC (inter-process communication) mechanism — safe, text-based, inspectable

---

## 📍 XP Drive Letter Detection

Because **Linux has no way to know which drive letter XP uses** for the shared folder (`/home/user` → e.g. `Z:\`), the XP-side program `xpserv.exe` scans for the correct drive and reports it back to Linux.

It writes the result to the shared control file `aja.ini`:

```ini
[XP]
ROOT=E:\
```

This field tells Linux that:
```
/home/user = E:\
/home/user/MXP = E:\MXP\
/home/user/ramdisk = E:\ramdisk\
```

This is critical for any Linux-side tool (`ajavahti`, `xpasso`, etc.) that needs to write back to the XP file system, e.g., when returning results or activating desktop elements.

---
## 🧠 Example Workflow

**User action (in XP):**
```cmd
linstart /usr/bin/thunar
```

**What happens:**
1. `linstart.exe` searches from A:\ to Z:\ until it finds `MXP\`
2. Finds e.g. `Z:\MXP\` → sets `startdir = Z:\ramdisk\`
3. Checks if `Z:\ramdisk\aja.ini` exists
4. If `[Aja] start=false` or missing:
    - Writes:
      ```
      [Aja]
      exe=/usr/bin/thunar
      path=c:\windows\command (not used when system=unix)
      start=true
      system=unix
      aktivoi=
      ```
5. On Linux, `ajavahti` sees the updated `aja.ini`, reads the fields, and runs `/usr/bin/thunar`
6. Linux clears or resets `start=false` after execution

---

## 🔁 Summary of Directory Roles

| Path                       | XP sees as       | Role                              |
|----------------------------|------------------|-----------------------------------|
| `/home/user/MXP`          | `Z:\MXP\`        | Main system folder (binaries etc.)|
| `/home/user/ramdisk`      | `Z:\ramdisk\`    | Temporary state (aja.ini etc.)    |
| (Any drive with MXP found)| `(can be X:\)`   | Detected dynamically              |

---

This structure ensures a clear, robust, and offline-safe method for communication between XP and Linux.

