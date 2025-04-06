# xpasso – Linux-to-XP Bridge Tool

**`xpasso`** is a Linux-side utility for MX·Link·XP.  
It prepares the `aja.ini` control file so that Windows XP can open the selected file using its default file association.

---

## 🔍 Purpose

- Convert a Linux file path (e.g. `/home/user/file.pdf`) to Windows XP format (e.g. `e:\home\user\file.pdf`)
- Extract and set:
  - XP file path
  - Executable filename
  - Required flags (`system=xp`, `start=true`, `aktivoi=`)
- Trigger XP to open the file through its associated program

---

## 🧠 How It Works

1. Reads the Linux file path from the command line
2. Finds the user's home directory
3. Reads `aja.ini` from the shared `ramdisk` folder
4. Looks for `[XP]` section and `ROOT=` (e.g. `e:\`)
5. Converts Linux path → XP path
6. Updates `[Aja]` section in `aja.ini` with:
   - `exe=...`
   - `path=...`
   - `system=xp`
   - `start=true`
   - `aktivoi=`

---

## ⚠️ Requirements

- `xpserv.exe` must be the **updated version**
  - It must support:
    - `[XP]` → `ROOT=`
    - Non-`.exe` file types (e.g. `.pdf`, `.jpg`, `.ods`)
    - Default XP file associations
- Shared RAM disk must be mounted in both systems
- `[XP]` → `ROOT=` must be correctly defined in `aja.ini`

---

## ✅ Example Usage

```bash
xpasso /home/user/Documents/myfile.pdf
```

This updates `aja.ini` like so:

```
[Aja]
exe=myfile.pdf
system=xp
aktivoi=
start=true
path=e:\home\user\Documents\
```

Now, XP will automatically open the file using its associated PDF viewer.

---

## 🖥️ Desktop Integration

You can register `xpasso` as a file handler in Linux for specific file types.

Example `.desktop` file for PDF:

```
[Desktop Entry]
Name=Adobe PDF Reader for XP
Exec=/usr/bin/xpasso %f
Icon=acroread
Type=Application
MimeType=application/pdf;
NoDisplay=false
```

Register with:

```bash
xdg-mime default xpasso.desktop application/pdf
```

You can create similar `.desktop` files for:

- `xpgimp.desktop` → send image files to XP GIMP
- `xppaint.desktop` → send BMP files to XP Paint
- `xpxcel.desktop` → send `.xls` files to XP Excel

---

## 🔧 Optional: XP Window Focus

To bring the XP VM window to front after triggering, append this line in `xpasso.c`:

```c
system("wmctrl -a \"xp\"");
```

Or customize for VMware/VirtualBox window titles.

---

## 🛠 Troubleshooting

| Problem                   | Cause / Fix                                         |
|---------------------------|-----------------------------------------------------|
| "XP root path not found"  | `[XP]` → `ROOT=` missing in `aja.ini`              |
| Nothing happens in XP     | `xpserv.exe` outdated or not running               |
| File opens in Linux       | MIME type not registered correctly for `xpasso`    |
| Incorrect filename/path   | Make sure file exists and path is accessible       |

---

## 🤝 License

`xpasso` is part of the MX·Link·XP system.  
You may use, modify, and redistribute it freely.  
No warranties or guarantees – use at your own risk.

---

## 🙏 Credits

Created as part of **MX·Link·XP** by  
**Asko**, for real-world seamless integration between modern Linux and legacy XP environments.
