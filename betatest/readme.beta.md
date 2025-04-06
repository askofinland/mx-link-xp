# MX·Link·XP – Beta Branch (Testing in Progress)

This branch contains upcoming and experimental features before official release.  
Focus is on **stability and logic**, not performance.

## 🔧 Components under Test

| Component    | Status    | Description                                                   |
|--------------|-----------|---------------------------------------------------------------|
| `ajavahti`   | ✅ Ready  | Linux-side daemon that reacts to `aja.ini` and prints PDFs    |
| `xpserv.exe` | ✅ Updated| XP-side daemon that reads `aja.ini` and executes commands     |
| `xpasso`     | ✅ New    | Linux tool that translates Linux paths to XP format and triggers XP execution |

> ⚠️ **Note:** `xpasso` **requires the updated version of** `xpserv.exe`.  
> Older versions of `xpserv.exe` do not support non-`.exe` file types or `[XP]` → `ROOT=` lookup logic.


## 🧪 What to Test

- Triggering commands via `[Aja]` section in `aja.ini`
- Automatic printing of `.pdf` files from the shared RAM folder
- Full communication cycle between Linux and XP via `aja.ini`
- Fast reaction (~100 ms) to `aja.ini` changes
- 🗑️ Removed: XP window polling (was unreliable and unnecessary)

## 🛠 How to Run

### 1. Build and launch `ajavahti` on Linux

```
gcc -o ajavahti ajavahti.c
./ajavahti /home/username/ramdisk
```

Replace `/home/username/ramdisk` with the actual shared folder path.

### 2. Launch `xpserv.exe` on Windows XP

- Add to Startup:
  `C:\Documents and Settings\All Users\Start Menu\Programs\Startup\xpserv.exe`
- Or start manually during testing

## 🧰 Using `xpasso`

`xpasso` is a Linux-side tool that prepares `aja.ini` for XP-side execution. It:

- Converts a Linux-style path to XP-style (e.g. `/home/user/file.pdf` → `e:\home\user\file.pdf`)
- Extracts folder path and filename
- Inserts correct values into `[Aja]` section
- Sets `start=true` so XP reacts
- Automatically reads `[XP]` → `ROOT=` to know XP's view of root (`e:\` etc.)

### Example

```
xpasso /home/user/Documents/manual.pdf
```

Updates `aja.ini` to:

```
[Aja]
exe=manual.pdf
system=xp
aktivoi=
start=true
path=e:\home\user\Documents\
```

This makes `xpserv.exe` in XP run the default associated PDF viewer (like Adobe Reader) with that file.

## 📄 PDF Auto-Printing (via `ajavahti`)

When a `.pdf` is dropped into the shared folder, `ajavahti` will:

- Automatically send it to the default printer using `lp`
- Delete the file after successful printing
- Respond within ~100 ms

Perfect for: "Print from XP, process on Linux"

## 📂 Example `aja.ini`

```
[Aja]
exe=example.doc
system=xp
aktivoi=
start=true
path=c:\Documents and Settings\user\My Documents\

[XP]
ROOT=e:\
```

## 🧠 Version Compatibility

- `xpasso` **requires** the updated `xpserv.exe`
- New `xpserv.exe` features:
  - Adds `[XP]` section and `ROOT=` if missing
  - Executes files based on file extension associations (not just `.exe`)
  - Supports `.pdf`, `.jpg`, `.ods`, `.doc`, etc.

## 🔧 Recommended Desktop Integration

You can assign filetypes in Linux (e.g. Thunar) to `xpasso`:

Example `.desktop` entry:

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

```
xdg-mime default xpasso.desktop application/pdf
```

Also possible:
- `xpgimp.desktop` → opens images in XP GIMP
- `xppaint.desktop` → opens BMPs in XP Paint
- `xpxcel.desktop` → opens `.xls` in XP Excel

## ✅ Status Summary

| Feature                     | Status     |
|-----------------------------|------------|
| Forked daemon logic         | ✅ Stable  |
| PDF auto-print              | ✅ Works   |
| `aja.ini` command control   | ✅ Stable  |
| XP-side non-exe handling    | ✅ New     |
| Full Linux↔XP workflow      | ⏳ Testing |
| Thunar `.desktop` usage     | ✅ Works   |
| XP focus with `wmctrl`      | ✅ Optional|

## 🛠 Troubleshooting

| Problem                  | Solution                                         |
|--------------------------|--------------------------------------------------|
| Nothing happens          | Run `ajavahti` in terminal and check output     |
| PDF not printing         | Ensure `lp` works; check file permissions       |
| XP doesn't open file     | Use updated `xpserv.exe`; check file type assoc |
| Path incorrect           | Make sure `[XP]` → `ROOT=` exists in `aja.ini`  |

## 🙏 Credits

Thanks to **Asko** for inventing the concept, structure, and implementing system logic for MX·Link·XP. This beta would not exist without his design work and real-world testing.

> 🧪 This is a beta/testing branch. Bug reports, feedback, and edge-case examples are highly welcome!

> This is a test-focused release.  
Bug reports, feedback, and edge case examples welcome!
