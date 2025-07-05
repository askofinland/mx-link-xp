# Muutokset versiossa 1.04 – MX·Link·XP

Tämä versio tuo mukanaan uusia työkaluja ja parannuksia järjestelmän vakauteen, yhteensopivuuteen ja käytettävyyteen. Alla on yhteenveto uusista ominaisuuksista ja tehdyistä muutoksista.

---

## ✅ Uudet ominaisuudet

### 1. Menumaker_for_XP

GTK3-pohjainen graafinen Linux-ohjelma, jolla voidaan valita järjestelmän .desktop-tiedostoja ja luoda niistä Windows XP -yhteensopivia EXE-käynnistimiä.

- Esikatselee ikonit
- Testaa käynnistettävyyden
- Luo valmiit OpenWatcom-projektit XP:lle
- Projektit sijoitetaan: `/home/<käyttäjä>/MXP/xpstart/<ohjelma>/`

### 2. Uudistettu tulostusjärjestelmä

- **CutePDF on poistettu**
- XP-puolelle asennetaan:
  - HP Color LaserJet PS -ajuri
  - RedMon-portti (RPT1:) ohjattuna `<asematunnus>:\MXP\Printteri\Tulosta.exe`:hen
- `Tulosta.exe` kirjoittaa tiedoston ja ohjauspyynnön RAM-levylle
- Linuxin `ajavahti` daemon tunnistaa pyynnön ja tulostaa oletustulostimelle

### 3. `setup/linux.log`

- `install.sh` luo tämän tiedoston Linux-puolella
- Lokiin kirjataan komponenttien asennustila: `OK` / `FAIL`
- XP:n asennusohjelma lukee tiedoston ja päättää, mitä asennetaan

### 4. Teemojen asennusskripti

- **theme_installer.sh** tarjoaa valinnaisesti:
  - Windows 10 -ikoni- ja käyttöliittymäteeman
  - Windows XP (Luna)-tyylisen ulkoasun XFCE:lle

### 5. Antijumi (valinnainen)

- Erillinen C-kielellä kirjoitettu Linux-ohjelma
- Tarkkailee kiertosilmukan viivettä
- Sulkee raskaat prosessit (selaimet, Thunderbird, wineserver) viiverajan ylityttyä
- Ei asenneta automaattisesti – oma install.sh ja README
- Sijainti: `Utils/Antijumi/`

---

## ✏️ Muokatut ominaisuudet

### 1. Linuxin `install.sh`

- Päivitetty vastaamaan uutta kansiorakennetta
- Luo `setup/linux.log`
- Kysyy MenuMakerin asentamisesta
- Kysyy teemojen asentamisesta

### 2. XP:n asennusohjelma

- Lukee `setup/linux.log`-tiedoston
- Asentaa OpenWatcomin vain jos `MenuMaker_for_XP OK`
- Kopioi `linsrarter.exe` → `C:\Windows`
- Muita ohjelmia ja rekisterimerkintöjä päivitetty käyttöliittymässä

---
