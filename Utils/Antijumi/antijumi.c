/*
 * antijumi.c — Tämä estää koneen jumiutumisen
 *
 * Ohjelma mittaa, kestääkö kierto (esim. sleep) liian kauan.
 * Jos suoritus hidastuu yli sallitun rajan, se sulkee raskaita ohjelmia.
 * Raja määritetään komentoriviltä millisekunteina (esim. ./antijumi 25).
 */

#include <stdio.h>
#include <time.h>
#include <unistd.h>
#include <stdlib.h>

#define ODOTUS 10.0  // Odotusaika sekunteina

void sulje_sovellukset() {
    printf("⚠️  Antijumi: Suoritus hidastui! Suljetaan selaimet, Thunderbird ja wineserver.\n");
    fflush(stdout);

    (void)system("pkill -9 chrome");
    (void)system("pkill -9 chromium");
    (void)system("pkill -9 firefox");
    (void)system("pkill -9 opera");
    (void)system("pkill -9 thunderbird");
    (void)system("wineserver -k");
}

int main(int argc, char *argv[]) {
    if (argc != 2) {
        fprintf(stderr, "Käyttö: %s <raja_ms>\n", argv[0]);
        return 1;
    }

    char *endptr;
    double raja_ylitys = strtod(argv[1], &endptr);
    if (*endptr != '\0' || raja_ylitys <= 0) {
        fprintf(stderr, "Virheellinen raja-arvo.\n");
        return 1;
    }

    raja_ylitys /= 1000.0;  // muutetaan sekunneiksi

    struct timespec alku, loppu;
    double erotus;

    while (1) {
        clock_gettime(CLOCK_MONOTONIC, &alku);
        sleep((int)ODOTUS);
        clock_gettime(CLOCK_MONOTONIC, &loppu);

        long sec = loppu.tv_sec - alku.tv_sec;
        long nsec = loppu.tv_nsec - alku.tv_nsec;
        if (nsec < 0) {
            sec--;
            nsec += 1000000000;
        }

        erotus = sec + nsec / 1e9;
        double ero_ms = (erotus - ODOTUS) * 1000.0;
        double raja_ms = raja_ylitys * 1000.0;
        double prosentti = (ero_ms / raja_ms) * 100.0;

        if (ero_ms < 0) prosentti = 0;  // ei vielä kuormaa

        printf("🛡️  Antijumi: Kierto kesti %.6f sekuntia\n", erotus);
        printf("🔧 Kuormitus %.1f %% sulkurajasta\n", prosentti);
        fflush(stdout);

        if (erotus > (ODOTUS + raja_ylitys)) {
            sulje_sovellukset();
        }
    }

    return 0;
}
