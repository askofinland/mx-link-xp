# Menumaker – Linux-käyttöliittymä MX-Link-XP:lle

**Menumaker** on graafinen GTK3-ohjelma, jonka avulla voidaan valita Linuxin valikossa olevista ohjelmista jokin ja luoda sitä varten Windows XP -yhteensopiva käynnistin (EXE-tiedosto). Tämä työkalu kuuluu osana *MX-Link-XP*-järjestelmän versiota 1.04.

Sen avulla voidaan:

- selata järjestelmän `.desktop`-tiedostoja
- testata ohjelmien käynnistymistä
- esikatsella ohjelman ikonia
- luoda valmiit projektitiedostot XP-käynnistintä varten

Käynnistin luodaan OpenWatcomilla (ohjeet IDE:lle)

---

## Linux-asennus

Asennus tapahtuu *MX-Link-XP*:n `install.sh`-skriptillä, joka:

1. Kääntää `menumaker`-binäärin:
   ```bash
   gcc menumaker.c -o menumaker `pkg-config --cflags --libs gtk+-3.0 gdk-pixbuf-2.0`
   ```
2. Asentaa sen:
   ```bash
   install -m 755 menumaker /usr/bin/menumaker
   ```

GTK3 ja gdk-pixbuf tulee olla asennettuna, esim. Debian-pohjaisissa:
```bash
sudo apt install libgtk-3-dev libgdk-pixbuf2.0-dev
```

Käynnistys:
```bash
menumaker
```

---

## Projektikansion sijainti

`Menumaker` luo projektin aina polkuun:

```
/home/<käyttäjä>/MXP/xpstart/<ohjelman_nimi>/
```

Jaetussa VirtualBox-ympäristössä XP:stä katsottuna tämä näkyy polkuna:

```
Z:\MXP\xpstart\<ohjelman_nimi>\
```
(Z: voi olla muukin asematunnus)

Kansio sisältää:
- `program.c` – C-koodi joka kutsuu linsrarter.exe:tä
- `program.rc` – resurssitiedosto ikonille
- `program.ico` – kopio alkuperäisestä ikonista (vaatii muokkauksen XP-yhteensopivaksi)

---

## Ikonin tekeminen GIMPillä

Jos `program.ico` ei ole vielä valmiina, tee se näin:

1. Avaa GIMP XP:ssä
2. Avaa esim. `program.png`
3. Skaalaa kuva:
   - Valitse **Image → Scale Image**
   - Aseta kooksi **32 × 32** tai **48 × 48** pikseliä
4. Vie tiedosto:
   - **File → Export As**
   - Nimeä tiedostoksi `program.ico`
   - Valitse tiedostotyypiksi: *Microsoft Windows icon (.ico)*
5. Vientiasetuksissa:
   - ✔️ Valitse vain yksi kuvakoko
   - ✔️ Kuvakoko 32×32 tai 48×48
   - ✔️ Väriterävyys: max. **8-bit (256 väriä)**

Tallenna samaan kansioon kuin `program.c` ja `program.rc`.

---

## XP:llä – ohjelman kääntäminen OpenWatcomilla

1. Avaa **OpenWatcom IDE**

### Luo uusi projekti:

2. Valitse: **File → New Project**
3. Valitse kansio: `Z:\MXP\xpstart\<ohjelman_nimi>\`
4. Anna nimi, esim. `firefox`, ja paina **Save**

### New Target -ikkunassa:

- **Target OS**: `Windows NT (Win32)`
- **Environment**: `Character mode`
- **Target type**: `EXE`
- Paina **OK**

### Lisää lähdetiedostot:

7. Hiiren oikealla "Sources"-kohdassa → **New Source**
8. Valitse:
   - `program.c`
   - `program.rc`
   - `program.ico`

9. Tallenna projekti (Ctrl+S)

10. Valitse ylävalikosta: **Actions → Make All**

Valmis EXE (`program.exe`) löytyy nyt samasta kansiosta ja voidaan suorittaa XP:ssä.

---

## Suoritus XP:ssä

Tuplaklikkaa `program.exe`.  
💡 **Vinkki**: tee pikakuvake ja kopioi se kansioon:

```
C:\Documents and Settings\All Users\Käynnistä-valikko\Ohjelmat
```

Näin ohjelma löytyy suoraan XP:n käynnistävalikosta.

---

## Yhteenveto

- `menumaker` tekee XP:lle sopivan EXE-projektin Linux-ohjelmasta
- `program.exe` kääntyy helposti XP:ssä OpenWatcomilla
- Käyttöliittymä on sujuva ja XP-yhteensopiva
- Kaikki projektit tehdään hakemistoon:  
  `/home/<käyttäjä>/MXP/xpstart/<ohjelma>/`

---

## Kehittäjä

askofinland@live.com ← Lahjoituksia PayPalilla – tue kehitystyötä.  
Vapaa käyttö osana MX-Link-XP:tä.
