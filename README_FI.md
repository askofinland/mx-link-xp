# 🖥️ MX·Link·XP – Versio 1.0

**MX·Link·XP** on älykäs integrointikerros, joka yhdistää modernin **Linux**-työpöydän ja perinteisen **Windows XP** -ympäristön. Sen avulla voit suorittaa jokaisen tehtävän siellä, missä se toimii parhaiten — ilman verkkoyhteyttä, nopeasti ja saumattomasti.

---

## ⚙️ Mikä on MX·Link·XP?

MX·Link·XP ei ole pelkkä asennusohjelma — vaan **kaksisuuntainen käyttöliittymäjärjestelmä**, jossa:

- Windows XP hoitaa **vanhat ohjelmat** (esim. Winamp, vanhat Office-tiedostot) täydellä nopeudella ja yhteensopivuudella
- Linux hoitaa **modernit tehtävät** (esim. verkkoselaus, tulostus, tiedostonhallinta)

Tämä on mahdollista jaetun RAM-levyn (`aja.ini` + `.pdf`-tulostusjono) ja molempien järjestelmien apuohjelmien ansiosta.

---

## ✅ Ominaisuudet

- 💡 Suorita ohjelmat siellä, missä ne toimivat parhaiten
- 📂 Jaetut kansiot: Linuxin kotihakemisto näkyy XP:ssä aseman Z:\ kautta
- 🧠 Keskitetty INI-tiedosto (`aja.ini`) kommunikointia varten
- 🔄 Täysin kaksisuuntainen logiikka (XP ↔ Linux)
- 🖨️ XP tulostaa Linuxin ajureilla (PDF → tulostin)
- 🚫 XP:llä ei ole verkkoyhteyttä — **100 % offline ja turvallinen**
- 🔒 Ei rekisterimuutoksia eikä kolmannen osapuolen palveluita XP:ssä
- 📦 Kaikki binäärit ja lähdekoodi mukana
- 📷 Yhteensopiva VirtualBox-tilannekuvien kanssa

---

## 🧩 Komponenttien yleiskatsaus

| Komponentti      | Alusta   | Tehtävä                                      |
|------------------|----------|-----------------------------------------------|
| `ajavahti`       | Linux    | Taustaprosessi, joka valvoo `aja.ini`-tiedostoa ja tulostaa PDF:t |
| `iniwriter`      | Linux    | Kirjoittaa/päivittää arvoja `aja.ini`-tiedostoon |
| `xpasso`         | Linux    | Lähettää .exe-komentoja XP:lle                |
| `xpserv.exe`     | XP       | Lukee ja suorittaa `aja.ini`:n ohjeet         |
| `setup1.exe`     | XP       | Graafinen asennusohjelma                      |
| `install.sh`     | Linux    | Asentaa Linuxin taustapalvelut ja RAM-levyn   |
| `Desktop maker`  | XP       | Luo pikakuvakkeita manuaalisesti              |

---

## 🏁 Asennusvaiheet

### 1. Lataa ja pura

Lataa `MXP.zip`-paketti ja pura se hakemistoon:  
```bash
/home/user/MXP/
```

### 2. Asenna Linux-komponentit

```bash
cd ~/MXP/
chmod +x ~/MXP/setup/install.sh
~/MXP/setup/install.sh
```


Vastaa RAM-levyn koko -kysymykseen (oletus: 512M).

### 3. Määritä VirtualBox

- Asenna Windows XP virtuaalikoneeseen
- Jaa kansio `/home/user` nimellä `user`
- Ota automaattinen liittäminen käyttöön
- XP näkee sen aseman Z:\ kautta

### 4. Asenna XP-komponentit

XP:n puolella suorita `setup\setup.exe`  
Tämä avaa `setup1.exe`:n, graafisen asennusohjelman.

Seuraa näytön ohjeita.

---

## 🔐 Turvallisuusmalli

- **XP:llä ei ole verkkoyhteyttä**: verkkokortti pois päältä, palvelut pysäytetty
- **Linux hoitaa kaikki nykyaikaiset toiminnot**
- **Winea ei tarvita**
- **VirtualBoxin tilannekuva = nopea palautus**

---

## 📜 Lisenssi ja lähdekoodi

Kaikki Linuxin ja XP:n apuohjelmat sisältävät:

- ✅ Esikäännetyt binäärit
- 📂 Täydellinen lähdekoodi
- 📝 Kehittäjän dokumentaatio jokaisessa kansiossa

> 💬 Kaikki XP-työkalut on kirjoitettu VB6:lla yksinkertaisuuden ja virheenkorjauksen vuoksi.  
> Jos haluat kirjoittaa ne uudelleen C:llä — anna mennä! 🙌

---

## 🖼️ Logo

Projektin logo:  
**`Tux walk on the bliss (square).png`**  
Symbolinen kuva Linuxin Tux-maskotista kävelemässä XP:n klassisen taustakuvan yllä.

---

## 🧰 Mukana tulevat apuohjelmat

MX·Link·XP sisältää pieniä apuohjelmia, jotka helpottavat XP:n ja Linuxin välistä integraatiota:

### 📅 Tray Calendar (kalenteri tehtäväpalkissa)

Kevyt popup-kalenteri Windows XP:lle — aivan kuten LXDE:n paneelikellossa.

- ✅ Ei käytä prosessoria ollessaan suljettuna  
- ✅ Toimii ilman internetyhteyttä, ei riippuvuuksia  
- 📂 Sijainti: `Z:\MXP\Utils\calendar\calendar.exe`

Asennus automaattisesti käynnistyväksi XP:ssä:  
> Kopioi pikakuvake kohtaan: Käynnistä > Kaikki ohjelmat > Käynnistys

🛠️ [Katso koko README →](MXP/Utils/calendar/README.md)

---

### 🔁 Linstart (XP → Linux komentolähetys)

Komentoriviltä ajettava työkalu, jolla XP voi pyytää Linuxia käynnistämään ohjelmia. Käyttää jaettua RAM-levyä (`aja.ini`).

- ✅ Yksi EXE — ei vaadi asennusta  
- ✅ Mahdollistaa XP-ohjelmista Linux-komentojen lähettämisen  
- 📂 Sijainti: `Z:\MXP\Utils\Linstart\linstart.exe`

Esimerkki:
```cmd
linstart /usr/bin/thunar
```

🛠️ [Katso koko README →](MXP/Utils/Linstart/README.md)

---

## 🙋 Kiitokset & lahjoitukset

Tehty ❤️:lla nostalgisen kehittäjän toimesta, joka yhä nauttii XP:stä —  
mutta luottaa Linuxiin kaikkeen muuhun.

Jos haluat tukea kehitystä:

> **Paypal:** `askofinland@live.com`

---

## 🧠 Filosofia

> MX·Link·XP edustaa **vapautta**:  
> hyödyntää yhä toimivaa teknologiaa,  
> välttää tarpeettomat päivitykset  
> ja säilyttää digitaalisen elämän hallinnan.

📖 Lue koko [Projektitarina ja filosofia](Doc/project_story.md)  
Henkilökohtainen ja tekninen katsaus siihen, miksi MX·Link·XP on olemassa — ja miten se antaa XP:lle uuden elämän Linux-maailmassa.

Eläköön yhteensopivuus. 🐧🪟
