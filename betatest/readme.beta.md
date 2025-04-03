# MX·Link·XP – Betatest branch

This folder contains upcoming and experimental features before official release.

## Components under test

✅ `ajavahti` – unified Linux-side daemon  
✅ `xpserv` – improved XP-side daemon with window hiding support

## What to test

- Automatic XP window hiding when losing focus
- Updated `aja.ini` handling from both sides
- Multi-command interaction via shared ini

## How to run

1. Compile ajavahti:
   gcc -o ajavahti ajavahti.c -lX11

2. Run:
   ./ajavahti /home/user/ramdisk

3. In XP, run xpserv.exe (manually or via startup folder)

## Known issues

- Not yet production tested
- Logging missing in ajavahti (optional for debugging)

---
