# 🖥️ MX·Link·XP – Versio 1.04

**MX·Link·XP** on älykäs integrointikerros, joka yhdistää modernin **Linux**-työpöydän ja perinteisen **Windows XP** -ympäristön. Sen avulla voit suorittaa jokaisen tehtävän siellä, missä se toimii parhaiten — ilman verkkoyhteyttä, nopeasti ja saumattomasti.

---

## ⚙️ Mikä on MX·Link·XP?

MX·Link·XP ei ole pelkkä asennusohjelma — vaan **kaksisuuntainen käyttöliittymäjärjestelmä**, jossa:

- Windows XP hoitaa **vanhat ohjelmat** (esim. Winamp, vanhat Office-tiedostot) täydellä nopeudella ja yhteensopivuudella
- Linux hoitaa **modernit tehtävät** (esim. verkkoselaus, tulostus, tiedostonhallinta)

Tämä on mahdollista jaetun RAM-levyn (`aja.ini` + `tulosta.ps`-tulostusjono) ja molempien järjestelmien apuohjelmien ansiosta.

---

## ✅ Ominaisuudet

- 💡 Suorita ohjelmat siellä, missä ne toimivat parhaiten
- 📂 Jaetut kansiot: Linuxin kotihakemisto näkyy XP:ssä aseman Z:\ kautta
- 🧠 Keskitetty INI-tiedosto (`aja.ini`) kommunikointia varten
- 🔄 Täysin kaksisuuntainen logiikka (XP ↔ Linux)
- 🖨️ XP tulostaa RedMonin ja Tulosta.exe-ohjelman avulla Linuxin oletustulostimeen
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
| `MenuMaker`      | Linux    | Graafinen työkalu XP-käynnistimien luontiin Linux-ohjelmista |

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
chmod +x setup/install.sh
./setup/install.sh```

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
## Uutta versiossa 1.04

- Tulostustuki XP:stä RedMonin avulla
- `Tulosta.exe`: uusi tulostuksen käsittelyohjelma
- Ajavahdin tuki RAM-levylle ohjatuille PS-tulosteille
- Käyttöönotto ei vaadi verkkotulostinta tai XP-verkkokorttia

## Asennusohjeet XP:lle

### 1. Asenna HP-ajuri

- Ohjauspaneeli → Tulostimet ja faksit → Lisää tulostin
- Valitse portiksi **LPT1:**
- Valmistaja: **HP**
- Malli: **HP Color LaserJet PS**
- Viimeistele asennus normaalisti

### 2. Asenna RedMon

- Siirry kansioon `Z:\MXP\Printteri\redmon\`
- Aja `setup.exe` ja seuraa ohjeita

### 3. Luo RedMon-portti (RPT1:)

- Avaa HP-tulostimen ominaisuudet → välilehti **Portit**
- Valitse **Lisää portti** → Redirected Port → nimeksi `RPT1:`
- Valitse `RPT1:` ja paina **Määritä portti**

Asetukset:

- **Program to run**: `Z:\MXP\Printteri\Tulosta.exe`
- **Arguments**: *(tyhjäksi)*
- Poista valinta kohdasta **Prompt for filename**
- Laita valinta kohtaan **Run as user**

### 4. Ota RPT1: käyttöön

- Tulostimen ominaisuudet → Portit → Valitse `RPT1:` aktiiviseksi portiksi

### 5. Testitulostus

- Avaa esim. Muistio ja tulosta testisivu

## Linux-puolen tulostusdaemon

**ajavahti**-ohjelma tarkkailee RAM-levyä (esim. `/home/kuetron/ramdisk` tai `Z:\RAMDISK`) ja käsittelee PDF/PS-tiedostot, jotka `Tulosta.exe` sinne tallentaa.

Tiedostot tulostetaan automaattisesti Linuxin oletustulostimeen, jonka voi testata komennolla:

```bash
lp testisivu.pdf
```

## Tulosta.exe

XP:lle asennettava kevyt .exe-ohjelma, joka toimii RedMonin kautta ja ohjaa tulostuksen RAM-levylle.

## Yhteenveto

RedMon lisää XP:lle virtuaalisen tulostinportin, joka ohjaa tulostuksen `Tulosta.exe`:lle. Tämä ohjelma kirjoittaa tiedoston RAM-levylle, josta Linuxin ajavahti käsittelee ja tulostaa sen. Ratkaisu ei vaadi verkkoasetuksia eikä muuta kuin toimivan XP:n ja RedMon-portin asetukset.

---

## 📢 Versiopäivitys 1.03 → 1.04

Päivittääksesi version 1.03 → 1.04:

1. **Kopioi kaikki** uudet kansiot ja tiedostot `MXP.zip`-paketista vanhan päälle (korvaa kysyttäessä).
2. Aja **Linuxissa**:
   ```bash
   ./setup/install.sh
   ```
   Tämä päivittää `ajavahti`-ohjelman ja muut taustaprosessit.  
   Asennus kysyy myös, haluatko asentaa uuden **MenuMaker**-työkalun. Vastaa `k/e`.

3. Aja **XP:ssä**:
   - `setup\setup.exe`

4. Asenna **RedMon** XP:lle:
   - Suorita `Z:\MXP\Printteri\redmon\setup.exe`
   - Määritä RedMon-portti (esim. `RPT1:`) viittaamaan `Tulosta.exe`

5. Lisää ja määritä XP:lle tulostin:
   - Valitse **HP Color LaserJet PS**
   - Valitse portiksi **RPT1:**

Tulostus XP:stä Linuxiin on nyt valmis.


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
