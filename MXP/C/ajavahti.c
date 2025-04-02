#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/inotify.h>
#include <limits.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/stat.h>  // Tämä täytyy lisätä, jotta "struct stat" toimii

#define FILE_NAME "aja.ini"
#define PDF_FILE "tulosta.pdf"
#define EVENT_SIZE (sizeof(struct inotify_event))
#define BUF_LEN (1024 * (EVENT_SIZE + 16))


// Tallennetaan viimeisin tiedoston muokkausaika
time_t last_mod_time = 0;

#include <time.h>

void print_if_pdf_is_ready(const char *dir_path) {
    char pdf_path[PATH_MAX];
    snprintf(pdf_path, sizeof(pdf_path), "%s/%s", dir_path, PDF_FILE);

    struct stat file_stat;
    time_t last_checked_time = 0;
    
    // 🔹 Ensimmäinen tarkistus: Jos tiedostoa ei ole, poistutaan heti
    if (stat(pdf_path, &file_stat) != 0) {
        printf("PDF-tiedostoa ei löydy: %s. Ei tehdä mitään.\n", pdf_path);
        return;
    }

    // 🔹 Odotetaan, että PDF ei enää muutu
    while (1) {
        if (stat(pdf_path, &file_stat) != 0) {
            printf("PDF-tiedosto katosi odotuksen aikana: %s\n", pdf_path);
            return;
        }

        if (file_stat.st_mtime == last_checked_time) {
            break;  // Tiedosto ei ole muuttunut, voidaan tulostaa
        }

        last_checked_time = file_stat.st_mtime;
        printf("PDF muuttuu vielä, odotetaan 5 sekuntia...\n");
        sleep(5);  // Odotetaan 5 sekuntia ennen uudelleentarkistusta
    }

    // 🔹 Viimeinen tarkistus ennen tulostusta
    if (stat(pdf_path, &file_stat) != 0) {
        printf("PDF katosi juuri ennen tulostusta: %s. Ei tehdä mitään.\n", pdf_path);
        return;
    }

    printf("PDF on valmis, lähetetään tulostukseen: %s\n", pdf_path);

    char print_command[PATH_MAX + 50];
    snprintf(print_command, sizeof(print_command), "env -u DISPLAY lp \"%s\"", pdf_path);

    // Debug-tulostus
    printf("Suoritettava komento: %s\n", print_command);

    int ret = system(print_command);
    if (ret == 0) {
        printf("Tulostus onnistui, poistetaan tiedosto: %s\n", pdf_path);
        unlink(pdf_path);  // ✅ POISTETAAN vain, jos tulostus onnistui
    } else {
        printf("Tulostus epäonnistui: %s (Virhekoodi: %d). Tiedostoa EI poisteta.\n", pdf_path, ret);
    }
}


void update_ini_file(const char *dir_path) {
    char file_path[PATH_MAX];
    snprintf(file_path, sizeof(file_path), "%s/%s", dir_path, FILE_NAME);

    FILE *file = fopen(file_path, "r");
    if (!file) {
        perror("Tiedoston avaaminen epäonnistui");
        return;
    }

    char temp_path[PATH_MAX];
    snprintf(temp_path, sizeof(temp_path), "%s/aja.tmp", dir_path);
    FILE *temp = fopen(temp_path, "w");
    if (!temp) {
        perror("Väliaikaisen tiedoston avaaminen epäonnistui");
        fclose(file);
        return;
    }

    char line[512];
    while (fgets(line, sizeof(line), file)) {
        if (strncmp(line, "start=true", 10) == 0) {
            fprintf(temp, "start=\r\n");  // Muutetaan heti start=
        } else if (strncmp(line, "aktivoi=", 8) == 0) {
            fprintf(temp, "aktivoi=\r\n"); // Tyhjennetään aktivoi, jos aktivointi onnistui
        } else {
            fputs(line, temp);
        }
    }

    fclose(file);
    fclose(temp);
    rename(temp_path, file_path);
}

void execute_command(char *cmd, int unix_mode, char *activate_window, const char *dir_path) {
    if (strlen(activate_window) > 0) {
        printf("Yritetään aktivoida ikkuna: %s\n", activate_window);
        
        // Käytetään wmctrl-työkalua aktivointiin
        char activate_command[256];
        snprintf(activate_command, sizeof(activate_command), "wmctrl -a \"%s\"", activate_window);
        
        if (system(activate_command) == 0) {
            printf("Ikkuna aktivoitu onnistuneesti.\n");

            // Jos aktivointi onnistui, päivitetään ini-tiedosto
            update_ini_file(dir_path);
            return;  // Lopetetaan suoritus, koska aktivointi onnistui
        } else {
            printf("Ikkunan aktivointi epäonnistui, suoritetaan ohjelma normaalisti...\n");
        }
    }

    if (unix_mode) {
        char *unix_cmd = strstr(cmd, "/unix ");
        if (unix_cmd) {
            unix_cmd += 6;
        } else {
            unix_cmd = cmd;
        }
        printf("Suoritetaan komento (UNIX-mode): %s\n", unix_cmd);
        fflush(stdout);

        if (fork() == 0) {  // Lapsiprosessi suorittaa komennon taustalla
            execlp("sh", "sh", "-c", unix_cmd, (char *)NULL);
            perror("Komennon suoritus epäonnistui");
            exit(EXIT_FAILURE);
        }
    } else {
        printf("Suoritetaan komento: %s\n", cmd);
        fflush(stdout);

        if (fork() == 0) {  // Lapsiprosessi suorittaa komennon taustalla
            execlp("sh", "sh", "-c", cmd, (char *)NULL);
            perror("Komennon suoritus epäonnistui");
            exit(EXIT_FAILURE);
        }
    }
}

void process_ini_file(const char *dir_path) {
    char file_path[PATH_MAX];
    snprintf(file_path, sizeof(file_path), "%s/%s", dir_path, FILE_NAME);

    FILE *file = fopen(file_path, "r");
    if (!file) {
        perror("Tiedoston avaaminen epäonnistui");
        return;
    }

    char line[512];
    char command[512] = "";
    char activate_window[128] = "";
    int start_flag = 0;
    int unix_mode = 0;

    while (fgets(line, sizeof(line), file)) {
        if (strncmp(line, "exe=", 4) == 0) {
            strcpy(command, line + 4);
            command[strcspn(command, "\r\n")] = 0;
        }
        if (strncmp(line, "start=true", 10) == 0) {
            start_flag = 1;
        }
        if (strncmp(line, "system=unix", 11) == 0) {
            unix_mode = 1;
        }
        if (strncmp(line, "aktivoi=", 8) == 0) {
            strcpy(activate_window, line + 8);
            activate_window[strcspn(activate_window, "\r\n")] = 0;
        }
    }
    fclose(file);

    if (start_flag && command[0] != '\0') {
        update_ini_file(dir_path);
        execute_command(command, unix_mode, activate_window, dir_path);
    }
}

void watch_ini_file(const char *dir_path) {
    int fd = inotify_init();
    if (fd < 0) {
        perror("inotify_init epäonnistui");
        exit(EXIT_FAILURE);
    }

    int wd = inotify_add_watch(fd, dir_path, IN_MODIFY);
    if (wd < 0) {
        perror("inotify_add_watch epäonnistui");
        exit(EXIT_FAILURE);
    }

    printf("Odotetaan muutoksia hakemistossa: %s/%s...\n", dir_path, FILE_NAME);
    fflush(stdout);

    while (1) {
        char buffer[BUF_LEN];
        int length = read(fd, buffer, BUF_LEN);
        if (length < 0) {
            perror("read epäonnistui");
            exit(EXIT_FAILURE);
        }

        int i = 0;
        while (i < length) {
            struct inotify_event *event = (struct inotify_event *)&buffer[i];

            if (event->len && (event->mask & IN_MODIFY)) {
                if (strcmp(event->name, FILE_NAME) == 0) {
                    printf("Muutoksia havaittu %s-tiedostossa, käsitellään...\n", FILE_NAME);
                    fflush(stdout);
                    process_ini_file(dir_path);
                }
            }
            i += EVENT_SIZE + event->len;
        }

        sleep(1);  // Viive, jotta CPU-kuormitus pysyy alhaisena
    }

    inotify_rm_watch(fd, wd);
    close(fd);
}

void print_and_delete_pdf(const char *dir_path) {
    char pdf_path[PATH_MAX];
    snprintf(pdf_path, sizeof(pdf_path), "%s/%s", dir_path, PDF_FILE);

    if (access(pdf_path, F_OK) == 0) {  // Tarkistetaan, onko tiedosto olemassa
        printf("PDF-tiedosto havaittu: %s, lähetetään tulostukseen...\n", pdf_path);

        // Suoritetaan tulostus
        char print_command[PATH_MAX + 10];
        snprintf(print_command, sizeof(print_command), "lp \"%s\"", pdf_path);

        if (system(print_command) == 0) {
            printf("Tulostus onnistui, poistetaan tiedosto: %s\n", pdf_path);
            unlink(pdf_path);  // Poistetaan tiedosto
        } else {
            printf("Tulostus epäonnistui, tiedostoa ei poisteta: %s\n", pdf_path);
        }
    }
}

void watch_directory(const char *dir_path) {
    int fd = inotify_init();
    if (fd < 0) {
        perror("inotify_init epäonnistui");
        exit(EXIT_FAILURE);
    }

    int wd = inotify_add_watch(fd, dir_path, IN_CREATE | IN_MODIFY);
    if (wd < 0) {
        perror("inotify_add_watch epäonnistui");
        exit(EXIT_FAILURE);
    }

    printf("Seurataan hakemistoa: %s (tulosta.pdf)...\n", dir_path);
    fflush(stdout);

    while (1) {
        char buffer[BUF_LEN];
        int length = read(fd, buffer, BUF_LEN);
        if (length < 0) {
            perror("read epäonnistui");
            exit(EXIT_FAILURE);
        }

        int i = 0;
        while (i < length) {
            struct inotify_event *event = (struct inotify_event *)&buffer[i];

            if (event->len && (event->mask & (IN_CREATE | IN_MODIFY))) {
                if (strcmp(event->name, PDF_FILE) == 0) {
                    printf("PDF-tiedosto havaittu: %s, tarkistetaan muutokset...\n", event->name);
                    fflush(stdout);
                    print_if_pdf_is_ready(dir_path);  // KORJATTU RIVI
                }
            }
            i += EVENT_SIZE + event->len;
        }
        sleep(1);
    }

    inotify_rm_watch(fd, wd);
    close(fd);
}

int main(int argc, char *argv[]) {
    if (argc != 2) {
        fprintf(stderr, "Käyttö: %s <hakemisto>\n", argv[0]);
        exit(EXIT_FAILURE);
    }

    char *dir_path = argv[1];

    if (access(dir_path, F_OK) != 0) {
        perror("Annettua hakemistoa ei löydy");
        exit(EXIT_FAILURE);
    }

    // Forkataan prosessi taustalle
    pid_t pid = fork();
    if (pid > 0) {
        printf("Ohjelma käynnistetty taustalle, prosessin PID: %d\n", pid);
        exit(EXIT_SUCCESS);
    }
    if (pid < 0) {
        perror("fork epäonnistui");
        exit(EXIT_FAILURE);
    }

    // Irrota prosessi terminaalista (daemon-moodi)
    setsid();

    // Käsitellään ini-tiedosto kerran alussa
    process_ini_file(dir_path);

    // Forkataan prosessi INI-tiedoston tarkkailuun
    pid_t ini_watcher_pid = fork();
    if (ini_watcher_pid == 0) {
        watch_ini_file(dir_path);
        exit(EXIT_SUCCESS);
    }

    // Forkataan toinen prosessi PDF-tiedostojen tarkkailuun
    pid_t pdf_watcher_pid = fork();
    if (pdf_watcher_pid == 0) {
        watch_directory(dir_path);
        exit(EXIT_SUCCESS);
    }

    // Pääprosessi lopetetaan, koska tarkkailuprosessit ovat käynnissä
    exit(EXIT_SUCCESS);
}
