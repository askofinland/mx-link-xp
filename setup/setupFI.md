# MX·Link·XP – Täydellinen asennusopas

Tämä opas selittää, kuinka asennat **MX·Link·XP**-järjestelmän, joka yhdistää Windows XP -virtuaalikoneen Linux-työpöytääsi. Se mahdollistaa tiedostotyyppien, selainlinkkien ja sähköpostitoimintojen täyden uudelleenohjauksen XP:stä Linuxiin.

---

## ✅ Vaihe 1: Lataa ja pura

Lataa asennuspaketti `mx-link-xp-1.x.zip` GitHubin Releases-osiosta.

Pura se ja nimeä kansio `MXP`, siirrä se sitten hakemistoon `/home/user/`.

```bash
unzip ~/Downloads/mx-link-xp-1.*.zip
mv mx-link-xp-1.* MXP
mv MXP ~/  # Nyt polku on /home/user/MXP

> **Tärkeää:** Älä **muuta** kansion nimiä tai polkuja. Kaikki sovellukset ja skriptit edellyttävät, että kansio on juuri `/home/user/MXP/`.
```

---

## 🛠️ Vaihe 2: Asenna VirtualBox Linuxiin

### Debian / Ubuntu / MX Linux:

```bash
sudo apt update
sudo apt install virtualbox virtualbox-ext-pack
```

### Arch / Manjaro:

```bash
sudo pacman -S virtualbox virtualbox-ext-vnc
```

---

## 🖥️ Vaihe 3: Luo Windows XP -virtuaalikone

1. Avaa **VirtualBox**.
2. Luo uusi virtuaalikone:
   * Nimi: `Windows XP`
   * Tyyppi: Microsoft Windows
   * Versio: Windows XP (32-bittinen)
3. Varaa muistia (suositus: 1024 MB).
4. Luo uusi virtuaalinen kiintolevy (VDI, dynaamisesti allokoitu, 50 GB).

Asenna Windows XP normaalisti ISO-kuvalla tai fyysiseltä levyltä.

---

## ⚙️ Vaihe 4: Määritä VirtualBox-asetukset

### 🕉 Asenna Guest Additions:

1. Käynnistä XP-virtuaalikone.
2. VirtualBox-valikosta:
   `Laitteet` → `Lisää Guest Additions CD -kuva…`
3. Suorita `VBoxWindowsAdditions.exe` XP:ssä ja käynnistä kone uudelleen.

### 🕿 Ota USB-tuki käyttöön:

```bash
sudo usermod -aG vboxusers $USER
```

> **Kirjaudu ulos ja takaisin sisään**, jotta ryhmämuutokset tulevat voimaan.

### 📁 Jaetun kansion asetukset:

1. XP:n VirtualBox-asetuksissa:
   * Mene kohtaan **Shared Folders**.
   * Klikkaa **+** lisätäksesi kansion.
2. **Kansion polku:** `/home/user`
3. **Kansion nimi:** `user`
4. ✅ Ota käyttöön `Auto-mount`
5. ✅ Ota käyttöön `Make Permanent`

XP:ssä tämä kansio näkyy seuraavasti:

```
Z:\  =  /home/user
```

> **Huom:** Aseman kirjain (esim. `Z:\`) voi vaihdella järjestelmäsi mukaan.  
> Tämä jaettu kansio on välttämätön MX·Link·XP:n toiminnalle.

---

## 🐧 Vaihe 5: Asenna Linux-puolen komponentit

Siirry MX·Link·XP:n asennuskansioon ja suorita asennusskripti **normaalikäyttäjänä** (älä käytä `sudo`):

```bash
cd ~/MXP/
chmod +x ~/MXP/setup/install.sh
~/MXP/setup/install.sh
```

> ⚠️ **Älä suorita tätä skriptiä `sudo`-komennolla!**  
> Se pitää ajaa normaalikäyttäjänä, jotta oikea työpöytäkansio (`~/Työpöytä` tai `~/Desktop`) voidaan tunnistaa.

Sinulta kysytään **RAM-levyn kokoa** (oletus: `512M`).

Skripti tekee seuraavat toiminnot:

* Tarkistaa, että kaikki tarvittavat binäärit löytyvät
* Kopioi `ajavahti`, `iniwriter` ja `xpasso` binäärit hakemistoon `/usr/bin`
* Asentaa apuskriptin `/usr/bin/XPserver`, joka tulostaa tervetuloviestin ensimmäisellä ajolla
* Tunnistaa XP:n .desktop-käynnistimen (esim. `xp.desktop`)
* Purkaa siitä oikean VirtualBox-komennon
* Luo uuden järjestelmälaajuisen käynnistyskomennon:
  `/usr/bin/xp`

Uusi `xp`-komento:

1. Liittää `~/ramdisk` tmpfs RAM-levyksi
2. Käynnistää `ajavahti`-prosessin taustalle RAM-levyä käyttäen
3. Käynnistää XP-virtuaalikoneen
4. Irrottaa RAM-levyn XP:n sulkeutuessa

Lisäksi se muuttaa työpöydän alkuperäisen .desktop-tiedoston käyttämään:

```ini
Exec=xfce4-terminal --working-directory=$HOME -e xp
```

Voit siis käynnistää XP:n työpöytäsymbolista tai kirjoittamalla `xp` päätteeseen.

---

## 🪠 Vaihe 6: Asenna XP:n puolen ohjelmisto

1. XP-virtuaalikoneessa avaa:

```
Z:\MXP\setup
```

> **Huom:** Aseman kirjain (esim. `Z:\`) voi vaihdella järjestelmäsi mukaan.

2. Suorita:

```
setupXP.exe
```

Tämä käynnistää **MX·Link·XP:n graafisen asennusohjelman**.

---

### ✅ Asennusohjelman ominaisuuksia:

- Moderni ulkoasu teemoitetuilla väreillä ja fontilla  
- Tunnistaa oikean asennuspolun automaattisesti  
- Voit valita asennettavat osat:
  - **Firefox**
  - **Thunderbird**
  - **MXlinkXP Media Player** (mediatiedostojen käsittelijä)
  - **Google Chrome -pikakuvake**
  - **MX-tiedostoselaimen pikakuvake**
  - **Linux-terminaalin pikakuvake**
  - **Chromiumin telakointikäynnistin**
  - **CuteWriter PDF-tulostin**
  - **Kalenteri** XP:n Käynnistys-kansioon  
- Asentaa:
  - XP:n taustaprosessin (`xpserv.exe`) Käynnistys-kansioon  
  - Tiedostotyyppien käsittelijät (esim. media MXlinkXP Media Playerilla)  
  - Apusovelluksia kuten **Desktop Maker**  
- Rekisteröi `COMDLG32.OCX`-komponentin, jos sitä ei vielä ole  
- Asennuksen jälkeen kysyy, haluatko suorittaa **Desktop Makerin**  
  → Tämä mahdollistaa pikakuvakkeen luomisen Linux-työpöydälle heti

---

### 💡 Vinkkejä asentajalle:

- **Asenna Firefox ja Thunderbird ensin käsin** graafisen asennusohjelman yläreunan painikkeilla  
- Kun valmis, klikkaa **"Install Server and Utilities"** asentaaksesi valitut osat  
- Asennuksen jälkeen näkyy vahvistus:
  ```
  Setup Complete – Server and utilities installed.
  ```

---

### 🔁 Lopuksi: Käynnistä XP uudelleen

> **Käynnistä Windows XP uudelleen asennuksen jälkeen.**  
> Tämä varmistaa, että `xpserv.exe`, **MXlinkXP Media Player** ja mahdollinen **Kalenteri** käynnistyvät automaattisesti.

---

## ✅ Yhteenveto

| Vaihe   | Kuvaus                                          |
|---------|--------------------------------------------------|
| Vaihe 1 | Pura `MXP.zip` hakemistoon `/home/user/MXP`     |
| Vaihe 2 | Asenna VirtualBox Linuxiin                      |
| Vaihe 3 | Luo Windows XP -virtuaalikone                   |
| Vaihe 4 | Määritä USB, Guest Additions ja jaettu kansio   |
| Vaihe 5 | Suorita Linuxin `install.sh`-asennusskripti     |
| Vaihe 6 | Suorita XP:n `setupXP.exe` jaetun kansion kautta |

---

## ℹ️ Asennuksen jälkeen

- Kaikki selainlinkit ja sähköpostitoiminnot XP:ssä ohjautuvat Linuxiin  
- `xpserv.exe` käynnistyy taustalle XP:n alussa  
- `/usr/bin/XPserver` tulostaa tervetuloviestin Linuxissa ensimmäisellä ajolla  
- `xdg-open.exe` hoitaa linkkien ja tiedostojen uudelleenohjauksen Linuxiin  
- Käytä **Desktop Maker** -sovellusta luodaksesi lisää mukautettuja pikakuvakkeita myöhemmin  
- Valinnainen kalenterityökalu käynnistyy XP:n alussa, jos valittu

🎉 Nauti saumattomasta Linux–XP-integraatiosta **MX·Link·XP**:n avulla!
