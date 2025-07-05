```markdown
# Menumaker – Linux GUI for MX-Link-XP

**Menumaker** is a graphical GTK3 application that lets you select programs from the Linux menu and create a Windows XP-compatible launcher (EXE file) for them. This tool is part of the *MX-Link-XP* system version 1.04.

It allows you to:

- browse system `.desktop` files
- test if applications start
- preview the application icon
- generate ready-to-use project files for an XP launcher

The launcher is compiled with OpenWatcom (see IDE instructions below)

---

## Linux Installation

Installed via the *MX-Link-XP* `install.sh` script, which:

1. Compiles the `menumaker` binary:
   ```bash
   gcc menumaker.c -o menumaker `pkg-config --cflags --libs gtk+-3.0 gdk-pixbuf-2.0`
   ```

2. Installs it:
   ```bash
   install -m 755 menumaker /usr/bin/menumaker
   ```

GTK3 and gdk-pixbuf must be installed. On Debian-based systems:

```bash
sudo apt install libgtk-3-dev libgdk-pixbuf2.0-dev
```

Run with:
```bash
menumaker
```

---

## Project Folder Location

`Menumaker` always creates the project at:

```
/home/<user>/MXP/xpstart/<program_name>/
```

In a shared VirtualBox setup, this is seen from XP as:

```
Z:\MXP\xpstart\<program_name>\
```
(Z: may differ)

The folder contains:
- `program.c` – C code that runs linsrarter.exe
- `program.rc` – resource file for icon
- `program.ico` – copy of the original icon (must be XP-compatible)

---

## Creating the Icon in GIMP

If `program.ico` is not ready, follow these steps:

1. Open GIMP in XP
2. Open e.g. `program.png`
3. Scale the image:
   - Select **Image → Scale Image**
   - Set size to **32 × 32** or **48 × 48** pixels
4. Export the file:
   - **File → Export As**
   - Name the file `program.ico`
   - Choose type: *Microsoft Windows icon (.ico)*
5. In export options:
   - ✔️ Select only one image size
   - ✔️ Size must be 32×32 or 48×48
   - ✔️ Color depth: max **8-bit (256 colors)**

Save it in the same folder with `program.c` and `program.rc`.

---

## In XP – Compile with OpenWatcom

1. Open **OpenWatcom IDE**

### Create a new project:

2. Choose: **File → New Project**
3. Set folder: `Z:\MXP\xpstart\<program_name>\`
4. Enter name, e.g., `firefox`, then **Save**

### In "New Target" window:

- **Target OS**: `Windows NT (Win32)`
- **Environment**: `Character mode`
- **Target type**: `EXE`
- Click **OK**

### Add source files:

7. Right-click on "Sources" → **New Source**
8. Select:
   - `program.c`
   - `program.rc`
   - `program.ico`

9. Save project (Ctrl+S)

10. From top menu: **Actions → Make All**

Now `program.exe` appears in the same folder and can be run on XP.

---

## Running on XP

Double-click `program.exe`.  
💡 **Tip**: Make a shortcut and copy it into:

```
C:\Documents and Settings\All Users\Start Menu\Programs
```

Now the program will show in XP's Start menu.

---

## Summary

- `menumaker` creates an EXE project for an XP launcher
- `program.exe` is easily built with OpenWatcom in XP
- GUI is smooth and XP-compatible
- All projects go to:  
  `/home/<user>/MXP/xpstart/<program>/`

---

## Developer

askofinland@live.com ← Donations via PayPal – support development.  
Free to use as part of MX-Link-XP.
```
