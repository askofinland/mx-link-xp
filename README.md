# 🖥️ MX·Link·XP – Version 1.0

**MX·Link·XP** is a smart integration layer that bridges a modern **Linux** desktop and a legacy **Windows XP** environment. It enables you to run each task on the platform where it performs best — with zero network connection, fast response, and seamless user experience.

---

## ⚙️ What is MX·Link·XP?

MX·Link·XP is **not just an installer** — it's a **two-way user interface system** where:

- Windows XP handles **legacy apps** (e.g. Winamp, old Office files) with full speed and compatibility
- Linux handles **modern tasks** (e.g. web browsing, printing, file management)

This is made possible by a shared RAM disk (`aja.ini` + `.pdf` queue) and a set of helper tools on both systems.

---

## ✅ Highlights

- 💡 Run programs where they work best
- 📂 Shared folders: Linux home is seen as `Z:\` in XP
- 🧠 Central INI file (`aja.ini`) for communication
- 🔄 Fully bidirectional logic (XP ↔ Linux)
- 🖨️ XP prints via Linux drivers (PDF → printer)
- 🚫 No network for XP — **100% offline and safe**
- 🔒 No registry tweaks or third-party services in XP
- 📦 All binaries included + source code
- 📷 VirtualBox snapshot compatible

---

## 🧩 Components Overview

| Component        | Platform | Role                                 |
|------------------|----------|--------------------------------------|
| `ajavahti`       | Linux    | Daemon that monitors `aja.ini` and prints PDFs |
| `iniwriter`      | Linux    | Writes/updates keys in `aja.ini`     |
| `xpasso`         | Linux    | Sends .exe commands to XP            |
| `xpserv.exe`     | XP       | Reads and runs instructions from `aja.ini` |
| `setup1.exe`     | XP       | Interactive installer                |
| `install.sh`     | Linux    | Installs Linux-side daemons and RAM disk |
| `Desktop maker`  | XP       | Creates shortcuts manually           |

---

## 🏁 Installation Steps

### 1. Download and Extract

Download the `MXP.zip` archive and extract to:  
```bash
/home/user/MXP/
```

### 2. Install Linux Components

```bash
cd ~/MXP/setup
chmod +x install.sh
./install.sh
```

Answer the prompt for RAM disk size (default: 512M).

### 3. Set Up VirtualBox

- Install Windows XP as a guest
- Map `/home/user` as a shared folder named `user`
- Enable auto-mount
- XP will see it as `Z:\`

### 4. Install XP Components

Inside XP, run `setup\setup.exe`  
This will launch `setup1.exe`, the graphical installer.

Follow on-screen instructions.

---

## 🔐 Security Model

- **XP has no network**: NIC disabled, services stopped
- **Linux handles all modern operations**
- **No Wine required**
- **VirtualBox snapshot = instant recovery**

---

## 📜 Licensing & Source

All Linux and XP-side tools include:

- ✅ Precompiled binary
- 📂 Full source code
- 📝 Developer documentation in each folder

> 💬 All XP tools were written in VB6 for simplicity and ease of debugging.  
> If anyone wants to rewrite them in C — go for it! 🙌

---

## 🖼️ Logo

Project logo:  
**`Tux walk on the bliss (square).png`**  
A symbolic image of Linux (Tux) walking safely through XP's classic background.

---

## 🙋 Credits & Donations

Made with ❤️ by a nostalgic developer who still enjoys XP —  
but trusts Linux for everything else.

If you'd like to support development:

> **Paypal:** `askofinland@live.com`

---

## 🧠 Philosophy

> MX·Link·XP is about **freedom**: to reuse what still works,  
> to skip unnecessary upgrades,  
> and to stay in control of your digital life.

Long live interoperability. 🐧🪟
