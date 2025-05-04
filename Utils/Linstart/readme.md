# 🔁 Linstart (linstart.exe)

**Linstart** is a small command-line utility for Windows XP, used as part of the MX·Link·XP integration system. It is responsible for passing an execution request from XP to Linux by writing to `aja.ini` on the shared RAM disk.

---

## 🧭 What It Does

- Scans drive letters to find the `\MXP\` directory  
- Writes launch instructions to `Z:\ramdisk\aja.ini`  
- Only triggers if `[Aja] start=false` (prevents overwriting ongoing commands)  
- Passes the given command (e.g. `/usr/bin/thunar`) to Linux

This utility allows XP programs to "request" that something be launched in Linux — such as file managers, terminals, or web browsers.

---

## ⚙️ How It Works

1. It checks all drives from `A:` to `Z:` looking for `MXP\`  
2. If found, it assumes the RAM disk is at `<drive>:\ramdisk\`  
3. Then it writes the following to `aja.ini`:
   ```
   [Aja]
   exe=/usr/bin/...
   path=c:\windows\command
   start=true
   system=unix
   aktivoi=
   ```

Linux-side daemon `ajavahti` will then detect this and execute the command accordingly.

---

## 🛠️ Recommended Installation

To make `linstart.exe` available from any location in XP:

1. Copy the file to:
   ```
   C:\WINDOWS\
   ```
2. Now you can run it from any program or command line without specifying the full path.

Example:
```cmd
linstart /usr/bin/firefox
```

This is useful when calling it from scripts or VB6 apps using `Shell`.



## 🧪 Example

Inside XP:

```cmd
linstart /usr/bin/thunar
```

This tells Linux to open the Thunar file manager, if no other command is active.

---

## 📂 Location in MX·Link·XP

- **Linux side:**  
  `/home/user/MXP/Utils/Linstart/linstart.exe`

- **Windows XP side (via shared folder):**  
  `Z:\MXP\Utils\Linstart\linstart.exe`

---

## 🛠️ Usage in VB6 Programs

VB6 applications in MX·Link·XP often use `Shell` to invoke `linstart` for Linux-bound actions.

Example:
```vb
Shell "Z:\MXP\Utils\Linstart\linstart.exe /usr/bin/firefox", vbHide
```

---

## 📝 License

Public domain — small and simple by design.

## 🙋 Credits & Donations

Made with ❤️ by a nostalgic developer who still enjoys XP —  
but trusts Linux for everything else.

If you'd like to support development:

> **Paypal:** `askofinland@live.com`

---

