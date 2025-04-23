# iniwriter.c – Developer Documentation

This tool is part of the **MX·Link·XP** project and is used to update key-value pairs in an INI-style configuration file (`aja.ini`). It reads a file containing `key=value` pairs and applies them to an existing target file. If the key exists, its value is updated; if not, it is appended.

---

## 🔧 Source File: `iniwriter.c`

### 🧠 Description

This C program reads an input file with `key=value` pairs and updates another INI-style file (output file) accordingly. It maintains the order and structure of the original output file, updating existing keys and appending new ones if needed.

---

## 📝 Translated Comments from Finnish

| Original (Finnish)                        | English Translation                                  |
|------------------------------------------|------------------------------------------------------|
| `// Rakenne avain-arvo-parien tallennukseen` | `// Structure to store key-value pairs`              |
| `// Lue tiedosto muistiin`               | `// Read file into memory`                          |
| `// Lisää uudet avaimet, joita ei vielä ollut` | `// Append new keys that were not already present` |

---

## 🧩 Functional Components

### `KeyValue` struct

```c
typedef struct {
    char key[MAX_KEY_LENGTH];
    char value[MAX_LINE_LENGTH];
} KeyValue;
```

Used to store the key and value pairs parsed from the input file.

---

### `starts_with(const char *line, const char *prefix)`

Checks whether a line starts with a given prefix. Used to match keys in the INI file.

---

### `trim_newlines(char *line)`

Removes `\n` and `\r` characters from the end of a string.

---

### `write_with_crlf(FILE *f, const char *line)`

Writes a line to the output file using Windows-style line endings (`\r\n`).

---

## 🚀 Usage

```bash
./iniwriter update.txt aja.ini
```

Where:
- `update.txt` contains key-value pairs to be updated.
- `aja.ini` is the file to modify.

---

## 🔄 How it Works

1. **Read Updates**:
   - Reads all `key=value` pairs from the input file.
2. **Load Original File**:
   - Reads the output file into memory if it exists.
3. **Apply Changes**:
   - For each original line:
     - If a key exists in both, update it.
     - Otherwise, leave it as-is.
4. **Append New Entries**:
   - Writes new keys from the input file that were not present in the output file.

---

## ✅ Output

The output file (`aja.ini`) is fully rewritten with updated and new values, preserving the file structure as much as possible.

---

## 🔐 Notes

- File reading and writing uses CRLF line endings (`\r\n`) to maintain Windows compatibility.
- Keys must match exactly, including case.
- The tool is safe to run multiple times; it will idempotently update the target file.

---

© 2025 MX·Link·XP Project
