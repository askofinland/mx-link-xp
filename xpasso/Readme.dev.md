# xpasso.c – Developer Documentation (README.dev.md)

This file documents the internal logic and purpose of the `xpasso.c` utility, which is part of the **MX·Link·XP** project. Its function is to convert a Linux-side `.exe` file path into a format that can be understood and executed on the Windows XP side inside VirtualBox.

---

## 💡 Purpose

When a user on the Linux side interacts with a `.exe` file (e.g. from the Thunar file manager), `xpasso` updates the `aja.ini` control file located in the `~/ramdisk` directory. This file acts as a command bridge between Linux and XP.

---

## ⚙️ Operation Flow

### 1. Arguments

```bash
Usage: ./xpasso <full_path_to_exe>
```

It accepts one argument: a full Linux path to an `.exe` file.

---

### 2. Environment

It uses the `$HOME` environment variable to construct the path to:
```
$HOME/ramdisk/aja.ini
```

If the `HOME` variable is missing, it exits with an error.

---

### 3. Read and Parse `aja.ini`

The file is read into memory (up to 512 lines), stored in an array of strings.

```c
// Read file into memory
```

---

### 4. Parse `[xp]` section

Looks for a section `[xp]` and then locates the `root=` line to extract the XP drive root (e.g. `Z:\`).

```c
// Search for [XP] and ROOT=
```

---

### 5. Parse `[Aja]` section

Looks for the `[Aja]` section and searches for existing values:

- `path=...` (target folder)
- `exe=...` (filename)
- `system=xp`
- `start=true`
- `aktivoi=...`

If `start=true` is already active, it returns `busy` and exits early.

```c
// Search [Aja] section and its fields
```

---

### 6. Convert Linux path to XP path

Example:
```
/home/user/ramdisk/foo/bar.exe
↓
Z:\foo\bar.exe
```

Extracts the filename (`bar.exe`) and its XP path (`Z:\foo\`).

```c
// Convert Linux path to XP-style path
```

---

### 7. Replace or Add Fields

- Replaces values if lines exist.
- Adds missing values to the end of the `[Aja]` section.

```c
// Replace existing lines
// Add missing lines to [Aja] section
```

---

### 8. Write Updated `aja.ini`

Overwrites the original file with the updated lines, preserving line order.

```c
// Write file back
```

---

### 9. Bring XP Window to Foreground

Executes:

```bash
wmctrl -a XP
```

Brings the VirtualBox window labeled “XP” to the front.

```c
// Bring XP window to foreground
```

---

## ✅ Output Example (`aja.ini`)

```ini
[xp]
root=Z:\

[Aja]
path=Z:\foo\
exe=bar.exe
system=xp
start=true
aktivoi=
```

---

## 📌 Summary Table

| Feature                 | Description                                           |
|------------------------|-------------------------------------------------------|
| Input                  | Linux path to `.exe` file                             |
| Output                 | Updates `aja.ini` with XP-compatible path             |
| Usage scope            | Called by Linux apps (e.g., right-click in Thunar)    |
| Output file            | `~/ramdisk/aja.ini`                                   |
| Activates XP Window    | via `wmctrl`                                          |
| Detection of busy flag | Returns "busy" if XP is already processing a request  |

---

## 📝 Developer Notes

- Code is now in UTF-8 encoding.
- Originally designed for integration with `ajavahti` and `xpserv.exe`.
- All internal comments were originally in Finnish and have been translated for clarity.

---

© 2025 MX·Link·XP Project – Developer Documentation v1.0
