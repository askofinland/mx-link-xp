# 🔔 Note for Beta Testers – MX·Link·XP

## Thank you!

Special thanks to all the beta testers who helped shape MX·Link·XP.

Your feedback, ideas, and testing efforts made version **1.0** more stable, usable, and powerful.

---

## ⚠️ Important Notice: Directory Structure Change in 1.0

The final version 1.0 introduces a **breaking change** in how shared folders are mapped between Windows XP and Linux:

| Version     | XP Path      | Linux Path        |
|-------------|--------------|-------------------|
| **Beta**    | `Z:\home\user` | `/home/user/`   |
| **1.0**     | `Z:\`          | `/home/user/`   |

### ✅ New 1.0 Standard:
- The entire Linux home directory (`/home/user`) is now directly mapped to `Z:\`
- This simplifies path conversion and ensures better compatibility with XP programs

---

## 🛑 Compatibility Warning

Because of this change:

- **Beta-era utilities or configuration files** (e.g., older `aja.ini` files) are **not compatible** with version 1.0
- Do **not mix** beta `.exe` files with 1.0 setup
- All components must come from the 1.0 release package

---

## ✅ Benefits of the Change

- No need to share the root (`/`) folder anymore — more secure and isolated
- XP applications that had issues with deep paths or symbolic links now behave correctly
- Simplifies all path handling logic in both XP and Linux

---

## 🙏 Once again, thank you.

This change was made based on your reports — it helps make MX·Link·XP more robust and easier to maintain.

– The Developer
