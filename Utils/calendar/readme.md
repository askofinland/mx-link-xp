# 📅 Tray Calendar for Windows XP

**Tray Calendar** is a lightweight system tray utility for Windows XP that shows a popup calendar when the tray icon is clicked — just like the calendar popup in LXDE's panel clock.

---

## 🧭 What It Does

- Adds a small tray icon with a clock/calendar tooltip  
- Left-clicking the icon shows or hides a native Windows calendar  
- Calendar appears in the lower-right corner of the screen  
- No background activity — zero CPU and RAM usage when closed  
- No dependencies, no registry changes, no network

This is a faithful LXDE-style calendar popup — nothing more, nothing less.

---

## 📂 Location in MX·Link·XP

This utility is located in:

- **Linux side:**  
  `/home/user/MXP/Utils/calendar/calendar.exe`

- **Windows XP side (via shared folder):**  
  `Z:\MXP\Utils\calendar\calendar.exe`

---

## 🛠️ Installation (Windows XP)

To have Tray Calendar launch automatically with Windows XP:

1. In XP, open:
   ```
   Z:\MXP\Utils\calendar\
   ```
2. Right-click `calendar.exe` and select **Copy**
3. Open the Start Menu
4. Navigate to:  
   ```
   Start > All Programs > Startup
   ```
5. Right-click the **Startup** folder and select **Open**
6. Right-click inside the folder and select **Paste Shortcut**

Done! The tray calendar will now start automatically when Windows XP boots.

---

## 🔐 Security & Compatibility

- Runs entirely offline — no internet, no telemetry  
- No registry modifications  
- No data is saved  
- Works from any folder, including shared `Z:\` or RAM disk  
- Designed for Windows XP (and similar classic systems)

---

## 📦 Source & Build

Source files are in the same folder:

```
Z:\MXP\Utils\calendar\
```

Build with Open Watcom:
```bash
wrc calendar.rc
wcl calendar.c calendar.res
```

Produces: `calendar.exe`

---

## 📝 License

Public domain — no restrictions, no obligations.


## 🙋 Credits & Donations

Made with ❤️ by a nostalgic developer who still enjoys XP —  
but trusts Linux for everything else.

If you'd like to support development:

> **Paypal:** `askofinland@live.com`

---
