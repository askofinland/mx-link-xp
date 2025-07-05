#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <io.h>
#include <fcntl.h>
#include <unistd.h>

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <io.h>
#include <fcntl.h>
#include <unistd.h>

int main(void) {
    char drive;
    char path[260];
    char finalfile[300];
    char logfile[300];
    FILE *f, *log;
    int found = 0;
    char buf[4096];
    size_t n;

    // Etsi asema, jossa \MXP-hakemisto löytyy
    for (drive = 'C'; drive <= 'Z'; drive++) {
        sprintf(path, "%c:\\MXP", drive);
        if (access(path, 0) == 0) {
            found = 1;
            break;
        }
    }

    if (!found) return 1;

    // Tulostiedosto ja lokitiedosto
    sprintf(finalfile, "%c:\\ramdisk\\tallenna.ps", drive);
    sprintf(logfile, "%c:\\ramdisk\\tallenna.log", drive);

    // Odota että tiedosto poistuu
    while (access(finalfile, 0) == 0) {
        log = fopen(logfile, "a");
        if (log) {
            fprintf(log, "tallenna.ps löytyy, odotetaan 10 sek...\n");
            fclose(log);
        }
        sleep(10); // 10 sekuntia
    }

    // Avaa tiedosto kirjoitusta varten
    f = fopen(finalfile, "wb");
    if (!f) return 2;

    setmode(fileno(stdin), O_BINARY);

    while ((n = fread(buf, 1, sizeof(buf), stdin)) > 0) {
        fwrite(buf, 1, n, f);
    }

    fclose(f);

    log = fopen(logfile, "a");
    if (log) {
        fprintf(log, "Kirjoitus valmis: %s\n", finalfile);
        fclose(log);
    }

    return 0;
}
