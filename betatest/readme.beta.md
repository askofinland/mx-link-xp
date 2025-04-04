# MX·Link·XP – Beta Branch

This branch contains upcoming and experimental features before official release.  
The focus is on **stability**, not performance.

---

## 🔧 Components under test

✅ `ajavahti` – unified Linux-side daemon  
✅ `xpserv` – XP-side background process with focus detection and INI output

---

## 🧪 What to test

- Automatic detection of XP VM (VirtualBox or VMware)
- Window deactivation handling: XP loses focus → `aja.ini` updated
- Command triggering via `[Aja]` section in `aja.ini`
- Printing of **all `.pdf` files** in shared RAM directory
- Full round-trip communication via shared INI file

---

## 🛠 How to run

### 1. Build `ajavahti` on Linux:

```bash
gcc -o ajavahti ajavahti.c -lX11
```

### 2. Launch the daemon:

```bash
./ajavahti /home/user/ramdisk
```

This should point to the shared folder used with XP (e.g. `ramdisk`).

### 3. Start `xpserv.exe` on XP:

- Manually, or
- Add to Startup folder

---

## 🔍 How it works (logic)

| Step | Action |
|------|--------|
| 1️⃣  | Scan directory for any `.pdf` files → print and delete |
| 2️⃣  | Check `aja.ini` for `system=unix` + `start=true` → run command |
| 3️⃣  | Monitor active window title for `"xp"` + `"virtualbox"` or `"vmware"` |
| 🔁  | If XP VM loses focus → write `system=xp`, `start=true`, etc. to `aja.ini` |

---

## 💡 Supported XP environments

✔️ Oracle VM VirtualBox  
✔️ VMware Workstation / Player

Detection works by scanning the active window title with:

- `contains("xp")`  
- and `contains("virtualbox")` or `contains("vmware")`

---

## 🧾 Sample `aja.ini`

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

---

## 🚦 Status

- ✅ Stable loop with no forks or threads
- ✅ Active window polling via `X11`
- ✅ PDF printing and cleanup
- ✅ Debug output to `stderr`
- ⏳ Production testing pending

---

## 🔍 Troubleshooting

- If nothing seems to happen:
  - Run from terminal and check debug output
  - Ensure `wmctrl` and `lp` are installed
  - Verify X11 display is available
- You can test window titles with:
  ```bash
  wmctrl -l
  ```

---

## 📢 Special thanks

Thanks to **Asko** for defining the control flow, logic structure, and system design.

---

## 📁 Repository structure

```
.
├── ajavahti.c
├── xpserv.exe
├── README.beta.md ← this file
└── ramdisk/ ← shared working directory
```

---

This is a test-focused release.  
Bug reports, window title outputs, and testing feedback welcome!
