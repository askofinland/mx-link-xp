# Antijumi

Antijumi on kevyt C-ohjelma, joka valvoo järjestelmän suorituskykyä mittaamalla viiveen vakioidussa ajosilmukassa. Mikäli viive ylittää käyttäjän määrittämän raja-arvon, ohjelma sulkee automaattisesti ennalta määritetyt raskaat sovellukset kuten verkkoselaimet, Thunderbirdin ja wineserverin.

## Tarkoitus

Antijumi on suunniteltu erityisesti ympäristöihin, joissa koneen käyttöaika voi olla useita viikkoja ilman uudelleenkäynnistystä. Tällöin ohjelmat kuten selaimet saattavat kuormittaa järjestelmää kasvavassa määrin, mikä aiheuttaa hitautta ja heikentää käytettävyyttä. Antijumi pyrkii estämään tilanteet, joissa ainoa vaihtoehto olisi käynnistää kone uudelleen.

## Toimintaperiaate

Ohjelma mittaa kierron keston sekuntien tarkkuudella. Kierto sisältää oletuksena 10 sekunnin viiveen (`sleep`). Mikäli mitattu viive ylittää sallitun raja-arvon (käyttäjän määrittämä, millisekunteina), ohjelma suorittaa seuraavat toimet:

- Sulkee seuraavat prosessit `pkill -9`-komennolla:
  - `chrome`
  - `chromium`
  - `firefox`
  - `opera`
  - `thunderbird`
- Kutsuu `wineserver -k` sulkemaan Wine-taustaprosessit (jos käytössä)

Ohjelma toimii täysin automaattisesti. Mikäli määritetty viiveraja ylittyy, Antijumi suorittaa toimenpiteet välittömästi ilman käyttäjän vahvistusta. Tämä mahdollistaa tehokkaan reagoinnin tilanteissa, joissa järjestelmä on kuormittunut eikä käyttäjän syöte enää etene.


## Kääntäminen ja asentaminen

Käännä lähdekoodi ja siirrä binääri järjestelmän hakupolkuun:

```bash
gcc antijumi.c -o antijumi
sudo mv antijumi /usr/bin/
```

Tämän jälkeen voit suorittaa ohjelman mistä tahansa:

```bash
antijumi 30
```

Yllä oleva esimerkki käynnistää Antijumin taustalle ja sallii enintään 30 millisekunnin viiveen.

## Integrointi MX*link*XP:n kanssa

MX*link*XP:n asennus luo käynnistysskriptin `/usr/bin/xp`, jota käytetään XP-ympäristön ja sen tukiprosessien käynnistämiseen. Antijumin voi integroida suoraan tähän skriptiin lisäämällä seuraavan rivin:

```bash
antijumi 30 &
```

Lisää rivi tiedostoon `/usr/bin/xp` esimerkiksi juuri ennen XP:n käynnistystä. Näin Antijumi valvoo järjestelmää automaattisesti aina, kun MX*link*XP käynnistetään.

## Rajoitukset

- Ohjelma ei tee graafista ilmoitusta ennen prosessien sulkemista.
- Vain kovakoodatut prosessit suljetaan. Muut resurssia kuluttavat ohjelmat jäävät tarkkailun ulkopuolelle.
- Soveltuu ympäristöihin, joissa pkill on käytettävissä.

## Lisenssi

Tämä ohjelma on julkaistu avoimena lähdekoodina. Voit käyttää, muokata ja jakaa sitä vapaasti.

🇫🇮 Tukeminen
Jos Antijumista on ollut sinulle hyötyä, voit halutessasi tukea kehitystyötä:

PayPal: askofinland@live.com


