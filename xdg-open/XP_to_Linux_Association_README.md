
# 🪟 XP → 🐧 Linux Assocation Bridge: `xdg-open.exe`

This tool enables seamless launching of Linux applications from Windows XP by associating XP file types with a small VB6-built launcher (`xdg-open.exe`).

## 🔄 What It Does

When a file (e.g., `.c`, `.md`) is double-clicked in XP:

1. `xdg-open.exe` receives the file path via `Command$`
2. It locates the shared RAM-disk (e.g., `E:\home\user\ramdisk`)
3. Converts the Windows path to a Linux-style path (slashes changed to `/`)
4. Writes a new `[Aja]` section into `aja.ini`:
   - `exe=start.exe /unix /usr/bin/xdg-open /path/to/file`
   - `path=c:\windows\command`
   - `system=unix`
   - `start=true`
5. The Linux-side daemon (`ajavahti`) reads `aja.ini` and executes the command using `xdg-open`
6. The file is opened in Linux with the default associated application

## 📁 Example

Double-clicking `E:\home\user\ramdisk\notes.md` in XP triggers:

```ini
[Aja]
exe=start.exe /unix /usr/bin/xdg-open /home/user/ramdisk/notes.md
path=c:\windows\command
start=true
system=unix
```

Result: Leafpad or any default Markdown editor opens the file on the Linux desktop.

## 🧩 Requirements

- XP and Linux must share a RAM-disk folder (`E:\home\user\ramdisk` ↔ `/home/user/ramdisk`)
- `ajavahti` must be running on the Linux side
- `.md`, `.c`, or other file types must be associated in the XP registry with `xdg-open.exe`

## 🛠️ Setup Suggestion (XP registry)

Example registry entry for `.md` files:

```
[HKEY_CLASSES_ROOT\.md]
@="MXP.Markdown"

[HKEY_CLASSES_ROOT\MXP.Markdown\shell\open\command]
@="C:\Program Files\xplink\xdg-open.exe "%1""
```

## ✅ Why This Works

- Keeps XP simple and free from Linux binaries or editors
- Leverages XP's file association system
- Allows Linux to act as the runtime for modern applications

This setup is perfect for using XP purely as a user interface while Linux handles all processing, editing, and internet-related tasks.
