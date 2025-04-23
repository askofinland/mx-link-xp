# ajavahti - MX·Link·XP Core Daemon

This is the **core background process** for the Linux side of the MX·Link·XP bridge.

It is responsible for:
- Handling remote execution requests from Windows XP
- Watching for printable PDF files in RAM disk
- Automatically activating Linux windows
- Maintaining bidirectional control via the shared `aja.ini` file

---

## 🔧 Compilation

Compile using:

```bash
gcc -o ajavahti ajavahti.c
```

---

## 🧩 Functionality

### 1. `aja.ini` Control File

Located in the **shared RAM disk** (`~/ramdisk/aja.ini`), this file is written and read by both XP and Linux sides.

**Fields it supports:**

| Field        | Description                                     |
|--------------|-------------------------------------------------|
| `start=true` | Signals a new execution request                 |
| `exe=...`    | Specifies the command or program to run         |
| `system=...` | Must be `unix` to be accepted by Linux daemon   |
| `aktivoi=...`| Optional: Linux window name to activate         |

After execution, fields like `start=` and `aktivoi=` are **cleared**.

---

### 2. PDF Print Daemon

- Monitors the RAM disk for `.pdf` files.
- Once the file is complete (modification time stable), it runs:
  ```bash
  env -u DISPLAY lp "filename.pdf"
  ```
- Then deletes the file.

Useful for printing from XP to Linux-native printers.

---

### 3. Execution Daemon

- Watches `aja.ini` for `start=true`
- Executes the UTF-8 converted command (from ANSI) using:
  ```bash
  sh -c "your command"
  ```
- If `aktivoi` is set:
  - Waits up to 2 seconds for the named window to appear
  - Uses `wmctrl -a "window name"` to bring it to front

---

## 🧪 Debug Output

All debug messages are printed to `stderr`, for example:
```text
🌙 LINXPWatcher starting...
Run command: xed /home/user/readme.md
Activate window: wmctrl -a xed
```

---

## 🧹 Cleanup Strategy

- Uses a temporary `.tmp` file and `rename()` to safely modify `aja.ini`
- Ensures atomic update to avoid read/write collisions

---

## 📁 File Layout Example

```
~/ramdisk/
 ├── aja.ini         <- command control file (shared with XP)
 ├── somefile.pdf    <- printed and deleted automatically
```

---

## 🧠 Developer Notes

- The program uses **two forks**:
  - One for PDF monitoring
  - One for ini file monitoring
- Main process exits after forking; children keep running in background

---

## ✅ Future Enhancements (optional)

- Logging to file or system journal
- PID file support
- Configurable `lp` command
- Timeout for inactive jobs

---

## 📦 Maintained as part of [MX·Link·XP]

Created by askofinland@live.com, © 2025.

Feel free to contribute, fork or suggest improvements!
