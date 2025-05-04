# 🌉 The Core Bridge: Connecting Linux and Windows XP

At the heart of MX·Link·XP lies a **minimalistic yet powerful bridge** between two operating systems: a modern Linux host and an offline Windows XP guest.

This bridge is not a network, not a socket, and not a service —  
it is a shared file-based signal system built on **clarity, determinism, and security**.

---

## 🧱 Foundation: The Shared Runtime Space

The bridge physically exists in the Linux folder:

```
/home/user/ramdisk/
```

Mapped to XP as:

```
Z:\ramdisk\
```

This **RAM disk** is:

- Shared between XP and Linux (VirtualBox Shared Folder)
- Volatile (cleared on boot or logout)
- Writable from both sides
- Monitored by daemons or helper tools

It acts as the **communication surface** between the two OSes.

---

## 📄 The Bridge File: `aja.ini`

The file `aja.ini`, placed in the RAM disk, is the **single point of truth** for all inter-OS commands.

It is simple, text-based, human-readable, and parsed using standard INI logic.

There is always **only one command active at a time** — and this is controlled via:

```ini
[Aja]
start=true / false
```

This eliminates race conditions and allows predictable behavior.

---

## 🧠 The Three Pillars of the Bridge

### 1. 🧍 `xpserv.exe` (Windows XP side)

- Detects the shared folder drive (e.g., `Z:` or `E:`)
- Writes `[XP] ROOT=...` to `aja.ini`
- Monitors `[Aja]` block when `system=XP` to execute XP-side programs
- Can run in the background (e.g., Startup folder or scheduled)

#### Role:
> **Makes XP visible to Linux**

---

### 2. 🦾 `ajavahti` (Linux side)

- Runs as a background daemon or cron-style loop
- Monitors `aja.ini` for `[Aja] start=true and system=unix`
- Executes the command in `exe=...`
- May reset `start=false` when done
- Optionally logs events or errors

#### Role:
> **Acts on XP's requests in Linux**

---

### 3. 📄 `aja.ini` (shared file)

- Modified by XP tools (`linstart.exe`, `xpserv.exe`)
- Read and reset by Linux tools (`ajavahti`, `xpasso`)
- Used symmetrically in reverse direction (Linux → XP)

#### Structure Example:
```ini
[Aja]
exe=/usr/bin/thunar
start=true
system=unix
aktivoi=

[XP]
ROOT=E:\
```

---

## 🔄 Communication Cycle: XP → Linux

1. User clicks an XP shortcut (`Shell linstart.exe /usr/bin/firefox`)
2. `linstart` writes to `Z:\ramdisk\aja.ini`
3. `ajavahti` on Linux detects `start=true`
4. Runs `exe=/usr/bin/firefox`
5. Resets `start=false` to indicate completion

---

## 🔄 Reverse Cycle: Linux → XP

1. A Linux tool (e.g., `xpasso`) writes:
   ```ini
   [Aja]
   exe=C:\PROGRA~1\Winamp\winamp.exe
   system=windows
   start=true
   ```
2. XP-side `xpserv.exe` detects it
3. Launches the specified XP program
4. Optionally resets `start=false`

---

## 🚫 Concurrency and Safety

- Only **one system acts at a time**
- `start=true` = locked for action
- No parallel commands
- Logging or feedback can be implemented via separate files if needed

---

## 🧩 Summary

| Component    | Side     | Responsibility                             |
|--------------|----------|--------------------------------------------|
| `ramdisk/`   | Shared   | Runtime communication base                 |
| `aja.ini`    | Shared   | Control and signal file                    |
| `ajavahti`   | Linux    | Monitors ini, executes commands            |
| `xpserv.exe` | XP       | Monitors ini, executes XP-side actions     |

This bridge is what makes MX·Link·XP possible.  
No daemons, no daemons.  
Just simple logic and trust in one tiny file.
