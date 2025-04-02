# MX·Link·XP – Integroitu MX Linux + Windows XP -järjestelmä

**MX·Link·XP** (MXP) yhdistää MX Linuxin ja Windows XP:n saumattomasti samaan tietokoneeseen ilman dualboottia. XP toimii käyttöliittymänä, Linux hoitaa raskaan käsittelyn ja internetin. Järjestelmä on suunniteltu turvalliseksi, kevyeksi ja läpinäkyväksi.

## 🎯 Kenelle tämä on?

- Käyttäjille, jotka tuntevat Linuxin ja XP:n
- Ei tarvitse uusimpia Windows-versioita
- Ei haluta dualboottia
- Tarvitaan XP:n ohjelmia, mutta turvallisesti eristettynä

---

## 🔧 Vaatimukset

- **Isäntäjärjestelmä:** MX Linux (suositus: Xfce)
- **Vieraskäyttöjärjestelmä:** Windows XP (VirtualBox)
- **Jaettu kansio:**
  - Linux: `/home/user/ramdisk`
  - XP: `E:\home\user\ramdisk`
- **RAM-disk:** 64 Mt riittää

---

## 📦 Asennusvaiheet

### 1. Pura ZIP-arkisto

Esimerkiksi hakemistoon:

```
/home/user/MXP
```

### 2. Asenna Linux-taustaprosessi (ajavahti)

```bash
cp /home/user/MXP/C/ajavahti.c ~/
gcc -o ajavahti ajavahti.c
./ajavahti /home/user/ramdisk
```

> Tämä tarkkailee `aja.ini`-tiedostoa ja suorittaa komennot Linuxin puolella.

### 3. Asenna Desktop Maker XP:lle

- Suorita:
  ```
  /home/user/MXP/Utils/Desktop\ maker/Package/setup.exe
  ```
- Asennuspaikka: `C:\Program Files\Desktop maker\`
- Rekisteröi: `COMDLG32.OCX`
- Luo `.desktop`-pikakuvakkeita Linuxin työpöydälle

### 4. Asenna XP:n daemon (xpserv.exe)

Kopioi:

```
E:\home\user\MXP\xpserv\xpserv.exe → 
C:\Documents and Settings\All Users\Start Menu\Programs\Startup
```

XP käynnistää sen automaattisesti.

---

### 5. Asenna assosiaatio-ohjelmat

✅ Vaiheet:
- Lataa Firefox 40.0:
  [https://ftp.mozilla.org/pub/firefox/releases/40.0/](https://ftp.mozilla.org/pub/firefox/releases/40.0/)

- Asenna Firefox normaalisti XP:hen — tämä tekee siitä XP:n oletusselaimen.

1. Asenna alkuperäiset versiot:
   - Firefox
   - Thunderbird
   - VLC
2. Aseta ne oletusohjelmiksi XP:ssä
3. Korvaa niiden EXE-tiedostot MXP-versioilla:

```
Korvaa esim.
C:\Program Files\Mozilla Firefox\firefox.exe 
→ E:\home\user\MXP\Firefox\Firefox.exe
```

> Näiden avulla XP välittää tiedoston Linuxille, joka avaa sen.

---

### 6. Kopioi telakkaohjelmat

Kopioi nämä XP:n Käynnistä-valikkoon:

```
E:\home\user\MXP\Thunar\Thunar.exe
E:\home\user\MXP\terminaali\Terminal.exe
E:\home\user\MXP\Cromium\chromium.exe
E:\home\user\MXP\GoogleChrome\googlechrome.exe
```

Kansioon:

```
C:\Documents and Settings\All Users\Start Menu\Programs\
```

> Thunderbird toimii myös `mailto:`-assosiaatiossa ja XP-paneelin telakassa.

---

### 7. Luo .desktop-kuvakkeet muille XP-ohjelmille

Käytä **Desktop Maker** -ohjelmaa.

---

### 8. Asenna iniwriter Linuxiin

```bash
sudo cp /home/user/MXP/Utils/bin/iniwriter /usr/bin/
```

---

## 📂 Hakemistorakenne

`/home/user/MXP` sisältää:

- `C/` → Linux daemon
- `xpserv/` → XP:n daemon
- `Utils/` → iniwriter, Desktop Maker
- `Firefox/, vlc/, Thunar/, GoogleChrome/` → Telakkaohjelmat
- `ramdisk/` → jaettu kansio
- `aja.ini` → komentotiedosto

> `.desktop`-kuvakkeet eivät sijaitse tässä hakemistossa, vaan käyttäjän Linuxin työpöydällä.

---

## 🔐 Turvallisuus

- XP:ltä on poistettu nettiyhteydet
- Kaikki raskas käsittely tapahtuu Linuxissa
- Järjestelmä ei muodosta piiloyhteyksiä

---

## ❤️ Copyright ja lahjoitukset

**MX·Link·XP** on henkilökohtainen harrasteprojekti.

Voit käyttää, muokata ja jakaa tätä vapaasti.

💸 Jos järjestelmästä on sinulle hyötyä, harkitse pientä lahjoitusta:

**PayPal:** askofinland@live.com

---

## ⚠️ Vastuuvapauslauseke

**MX·Link·XP** toimitetaan "sellaisenaan".  
Käyttäjä käyttää ohjelmistoa täysin omalla vastuullaan.  
Kehittäjä ei ole vastuussa mistään vahingoista.

---
