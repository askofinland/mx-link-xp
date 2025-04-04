#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <limits.h>
#include <sys/stat.h>
#include <dirent.h>
#include <time.h>
#include <sys/types.h>

#define FILE_NAME "aja.ini"
#define MAX_LINE_LEN 2048

#define DEBUG(...) fprintf(stderr, __VA_ARGS__)

// --- PDF-TULOSTAJA ---

void print_and_delete_pdf(const char *pdf_path) {
    struct stat file_stat;
    if (stat(pdf_path, &file_stat) != 0) {
        DEBUG("⚠️ Tiedostoa ei löytynyt: %s\n", pdf_path);
        return;
    }

    DEBUG("📂 PDF löydetty: %s\n", pdf_path);
    time_t last_mtime = file_stat.st_mtime;

    while (1) {
        sleep(5);
        if (stat(pdf_path, &file_stat) != 0) {
            DEBUG("⚠️ Tiedosto katosi: %s\n", pdf_path);
            return;
        }
        if (file_stat.st_mtime == last_mtime) break;
        DEBUG("⏳ Odotetaan PDF:n valmistumista...\n");
        last_mtime = file_stat.st_mtime;
    }

    char cmd[PATH_MAX + 100];
    snprintf(cmd, sizeof(cmd), "env -u DISPLAY lp \"%s\"", pdf_path);
    DEBUG("🖨️ Tulostuskomento: %s\n", cmd);
    if (system(cmd) == 0) {
        unlink(pdf_path);
        DEBUG("🧹 Tiedosto tulostettu ja poistettu: %s\n", pdf_path);
    } else {
        DEBUG("❌ Tulostus epäonnistui: %s\n", pdf_path);
    }
}

void pdf_daemon(const char *dir_path) {
    while (1) {
        DIR *dir = opendir(dir_path);
        if (dir) {
            struct dirent *entry;
            while ((entry = readdir(dir)) != NULL) {
                const char *ext = strrchr(entry->d_name, '.');
                if (ext && strcasecmp(ext, ".pdf") == 0) {
                    char pdf_path[PATH_MAX];
                    snprintf(pdf_path, sizeof(pdf_path), "%s/%s", dir_path, entry->d_name);
                    print_and_delete_pdf(pdf_path);
                }
            }
            closedir(dir);
        }
        sleep(1);
    }
}

// --- INI-KÄSITTELIJÄ ---

void update_ini_file(const char *dir_path) {
    char file_path[PATH_MAX];
    snprintf(file_path, sizeof(file_path), "%s/aja.ini", dir_path);
    FILE *file = fopen(file_path, "r");
    if (!file) return;

    char tmp_path[PATH_MAX];
    snprintf(tmp_path, sizeof(tmp_path), "%s/aja.tmp", dir_path);
    FILE *tmp = fopen(tmp_path, "w");
    if (!tmp) {
        fclose(file);
        return;
    }

    char line[512];
    DEBUG("🧽 Tyhjennetään start/aktivoi INI:stä...\n");

    while (fgets(line, sizeof(line), file)) {
        if (strncmp(line, "start=true", 10) == 0) {
            fprintf(tmp, "start=\r\n");
        } else if (strncmp(line, "aktivoi=", 8) == 0) {
            fprintf(tmp, "aktivoi=\r\n");
        } else {
            fputs(line, tmp);
        }
    }

    fclose(file);
    fclose(tmp);
    rename(tmp_path, file_path);
}

void execute_command(char *cmd, char *activate, const char *dir_path) {
    // Aktivointi yrittää vain kerran
    if (strlen(activate) > 0) {
        char activate_cmd[256];
        snprintf(activate_cmd, sizeof(activate_cmd), "wmctrl -a \"%s\"", activate);
        DEBUG("🖱️ Aktivointi: %s\n", activate_cmd);
        if (system(activate_cmd) == 0) {
            update_ini_file(dir_path);
            return;
        }
    }

    // Poista "start.exe /unix" tai "/unix" komennon alusta
    char *clean_cmd = NULL;

    if ((clean_cmd = strstr(cmd, "start.exe /unix ")) != NULL) {
        clean_cmd += strlen("start.exe /unix ");
    } else if ((clean_cmd = strstr(cmd, "/unix ")) != NULL) {
        clean_cmd += strlen("/unix ");
    } else {
        clean_cmd = cmd;
    }

    DEBUG("🚀 Suoritetaan: %s\n", clean_cmd);

    if (fork() == 0) {
        execlp("sh", "sh", "-c", clean_cmd, (char *)NULL);
        exit(EXIT_FAILURE);
    }
}

void ini_daemon(const char *dir_path) {
    char ini_path[PATH_MAX];
    snprintf(ini_path, sizeof(ini_path), "%s/aja.ini", dir_path);

    while (1) {
        FILE *f = fopen(ini_path, "r");
        int start = 0, is_unix = 0;
        char cmd[512] = "", akt[128] = "";

        if (f) {
            char line[512];
            while (fgets(line, sizeof(line), f)) {
                if (strncmp(line, "start=true", 10) == 0) start = 1;
                if (strncmp(line, "system=unix", 11) == 0) is_unix = 1;

                if (strncmp(line, "exe=", 4) == 0) {
                    strcpy(cmd, line + 4);
                    cmd[strcspn(cmd, "\r\n")] = 0;
                }

                if (strncmp(line, "aktivoi=", 8) == 0) {
                    strcpy(akt, line + 8);
                    akt[strcspn(akt, "\r\n")] = 0;
                }
            }
            fclose(f);
        }

        if (start && is_unix && cmd[0] != '\0') {
            DEBUG("✅ start=true & system=unix -> suoritetaan.\n");
            update_ini_file(dir_path);
            execute_command(cmd, akt, dir_path);
        }

        usleep(100000);  // 100 000 mikrosekuntia = 100 ms

    }
}

// --- MAIN ---

int main(int argc, char *argv[]) {
    if (argc != 2) {
        fprintf(stderr, "Käyttö: %s <hakemisto>\n", argv[0]);
        return 1;
    }

    const char *dir_path = argv[1];

    DEBUG("🌙 Käynnistetään taustaprosessit...\n");

    pid_t pid1 = fork();
    if (pid1 == 0) {
        pdf_daemon(dir_path);
        exit(0);
    }

    pid_t pid2 = fork();
    if (pid2 == 0) {
        ini_daemon(dir_path);
        exit(0);
    }

    DEBUG("👋 Pääprosessi poistuu, taustaprosessit jatkavat.\n");
    return 0;
}
