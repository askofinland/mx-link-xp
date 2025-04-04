# MX·Link·XP – Beta Branch

This branch contains upcoming and experimental features before official release.  
The focus is on stability, not performance.

## 🔧 Components under test

✅ **ajavahti** – unified Linux-side daemon  
✅ **xpserv** – XP-side background process with INI output

## 🧪 What to test

- Command triggering via `[Aja]` section in `aja.ini`
- Printing of all `.pdf` files from shared RAM directory
- Full round-trip communication via shared INI file
- Fast response (100 ms) to changes in `aja.ini`

> 🗑️ **Removed:** XP window polling (VirtualBox/VMware) – feature was found impractical and confusing

## 🛠 How to run

### 1. Build `ajavahti` on Linux:

```bash
gcc -o ajavahti ajavahti.c
```

### 2. Launch the daemon:

```bash
./ajavahti /home/user/ramdisk
```

> The argument should point to the shared folder used with XP (e.g. `ramdisk`).

### 3. Start `xpserv.exe` on Windows XP:

- Manually, or  
- Add to Startup folder

## 🔍 How it works (logic)

| Step | Action |
|------|--------|
| 1️⃣   | Scan directory for any `.pdf` files → print and delete |
| 2️⃣   | Check `aja.ini` for `system=unix` and `start=true` → run command |

> The daemon runs in the background as two separate processes (forked): one for printing, one for command execution.

## 🖨️ PDF printing

All `.pdf` files found in the specified directory will be:

- Printed using `lp`
- Deleted after successful print
- Intended use: RAM-based shared folder between XP and Linux host

## 📝 Sample `aja.ini`

```ini
[Aja]
exe=WINWORD.EXE
system=xp
aktivoi=
start=true
path=c:\Program Files\Microsoft Office\OFFICE11

[Google Chrome]
Lock=True
```

## 🚦 Status

✅ Stable loop with forked daemons  
✅ PDF printing and cleanup  
✅ INI command triggering  
✅ Debug output to `stderr`  
⏳ Production testing pending

## 🔍 Troubleshooting

If nothing seems to happen:

- Run from terminal and check debug output
- Ensure `lp` is installed and available
- Verify that PDF files are present in the specified folder

## 📢 Special thanks

Thanks to **Asko** for defining the control flow, logic structure, and system design.

## 📁 Repository structure

```
.
├── ajavahti.c
├── xpserv.exe
├── README.beta.md ← this file
```

> This is a test-focused release.  
Bug reports, feedback, and edge case examples welcome!
