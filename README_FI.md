# 🖥️ MX·Link·XP – Versio 1.0

**MX·Link·XP** on älykäs käyttöliittymäkerros, joka yhdistää nykyaikaisen **Linux**-työpöydän ja vanhemman **Windows XP** -järjestelmän. Sen avulla voit suorittaa tehtävät siellä missä ne toimivat parhaiten — ilman verkkoyhteyttä, nopeasti ja vakaasti.

---

## ⚙️ Mikä on MX·Link·XP?

MX·Link·XP ei ole pelkkä asennusohjelma — se on **kaksisuuntainen käyttöliittymäratkaisu**, jossa:

- Windows XP hoitaa **vanhat sovellukset** (esim. Winamp, Excel 2003) nopeasti ja yhteensopivasti
- Linux hoitaa **modernit toiminnot** (esim. selain, tulostus, tiedostot)

Tämä toimii yhteisen RAM-levyn avulla, johon kirjoitetaan ohjaustiedosto `aja.ini` ja mahdolliset PDF-tulostustyöt.

---

## ✅ Ominaisuudet

- ⚡ Aja ohjelmat siellä missä ne toimivat parhaiten
- 📂 Jaettu kansio: Linuxin kotikansio näkyy XP:ssä `Z:\`-asemana
- 🧠 Keskusohjaus tiedostolla `aja.ini`
- 🔄 Kaksisuuntainen toiminta (XP ↔ Linux)
- 🖨️ Tulostus Linuxin kautta (PDF → tulostin)
- 🔒 XP ei ole verkossa – **100 % offline**
- 🧼 Ei rekisterin puhdistajia tai taustapalveluita XP:ssä
- 📦 Mukana sekä binäärit että lähdekoodit
- 📷 Tukee VirtualBoxin palautuspisteitä (snapshot)

---

## 🧩 Osat ja tehtävät

| Komponentti      | Alusta   | Tehtävä                             |
|------------------|----------|-------------------------------------|
| `ajavahti`       | Linux    | Taustaprosessi, lukee `aja.ini` ja käsittelee PDF-tulostuksia |
| `iniwriter`      | Linux    | Päivittää avain-arvoparit `aja.ini`-tiedostossa |
| `xpasso`         | Linux    | Kirjoittaa XP:n suoritettavia komentoja `aja.ini`:hin |
| `xpserv.exe`     | XP       | Taustapalvelu, lukee `aja.ini`-tiedostoa ja suorittaa käskyt |
| `setup1.exe`     | XP       | Graafinen asennusohjelma |
| `install.sh`     | Linux    | Linuxin asennusskripti (ajavahti, ramdisk, käynnistys) |
| `Desktop maker`  | XP       | Pikakuvakkeiden luontityökalu |

---

## 🏁 Asennusohjeet

### 1. Lataa ja pura

Lataa `MXP.zip` ja pura se kansioon:

```bash
/home/user/MXP/
```

### 2. Linux-asennus

```bash
cd ~/MXP/setup
chmod +x install.sh
./install.sh
```

Vastaa kysymykseen RAM-levyn koosta (oletus: 512M)

### 3. VirtualBox-asennus

- Asenna Windows XP virtuaalikoneeksi
- Jaa `/home/user` kansio nimellä `user`
- Valitse automaattinen liittäminen
- XP näkee kansion `Z:\`-asemana

### 4. XP-ohjelmien asennus

XP:ssä aja:  
```text
setup\setup.exe
```

Se avaa `setup1.exe`:n — seuraa ohjeita.

---

## 🔐 Turvamalli

- **XP ei ole verkossa**:
  - Verkkokortti poistettu käytöstä
  - Palvelut pysäytetty
- **Linux hoitaa kaiken modernin**
- **Ei tarvita Winea**
- **VirtualBox snapshot = nopea palautus**

---

## 📜 Lähdekoodi

Kaikki ohjelmat sisältävät:

- ✅ Valmiit binäärit
- 📂 Täydet lähdekoodit
- 📝 Kehittäjän dokumentaation kansioittain

> 💬 XP-ohjelmat on kirjoitettu **VB6:lla** kehittäjän nopeuden ja selkeyden vuoksi.  
> Jos haluat toteuttaa ne C:llä – siitä vaan! 🙌

---

## 🖼️ Logo

Projektilogo:  
**`Tux walk on the bliss (square).png`**  
Symbolinen kuva Tuxista (Linux) kulkemassa turvallisesti XP:n ikonista taustakuvaa pitkin.

---

## 🙋 Kiitokset & lahjoitukset

Tämän kehitti henkilö, joka edelleen arvostaa XP:tä —  
mutta luottaa Linuxiin kaikkeen tärkeään.

Jos haluat tukea:

> **Paypal:** `youremail@example.com`

---

## 🧠 Filosofia

> MX·Link·XP antaa sinulle vapauden käyttää edelleen toimivia asioita,  
> välttää tarpeettomat päivitykset,  
> ja hallita omaa digielämääsi.

**Yhteensopivuus on voimaa.** 🐧🪟
