#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <limits.h>
#include <sys/stat.h>
#include <dirent.h>
#include <time.h>

#define DEBUG(...) fprintf(stderr, __VA_ARGS__)

// ANSI → UTF-8
char *ansi_to_utf8(const char *ansi_str) {
    size_t len = strlen(ansi_str), maxlen = len * 2 + 1;
    char *utf8 = malloc(maxlen); if (!utf8) return NULL;
    unsigned char *src = (unsigned char *)ansi_str;
    char *dst = utf8;
    while (*src) {
        if (*src < 0x80) *dst++ = *src++;
        else { *dst++ = 0xC0 | (*src >> 6); *dst++ = 0x80 | (*src & 0x3F); src++; }
    }
    *dst = '\0';
    return utf8;
}

void print_file(const char *path) {
    char cmd[PATH_MAX + 100];
    snprintf(cmd, sizeof(cmd), "env -u DISPLAY lp \"%s\"", path);
    DEBUG("🖨️ %s\n", cmd);
    if (system(cmd) == 0 && unlink(path) == 0) {
        DEBUG("🗑️ Poistettu: %s\n", path);
    } else {
        perror("❌ Tulostus tai poisto epäonnistui");
    }
}

void watcher_pdf_and_ps(const char *dir_path, int copies) {
    while (1) {
        DIR *dir = opendir(dir_path);
        if (!dir) { perror("opendir"); sleep(2); continue; }

        struct dirent *entry;
        while ((entry = readdir(dir)) != NULL) {
            const char *name = entry->d_name;
            const char *ext = strrchr(name, '.');

            if (ext && strcasecmp(ext, ".ps") == 0) {
                char path[PATH_MAX];
                snprintf(path, sizeof(path), "%s/%s", dir_path, name);

                if (strcmp(name, "tulosta.ps") == 0) {
                    struct stat st1, st2;
                    if (stat(path, &st1) == 0) {
                        usleep(500000);
                        stat(path, &st2);
                        if (st1.st_mtime != st2.st_mtime) continue;

                        DEBUG("🖨️ tulosta.ps x%d\n", copies);
                        for (int i = 0; i < copies; i++)
                            print_file(path);
                        unlink(path);
                    }
                } else {
                    DEBUG("📄 PS löytyi: %s\n", path);
                    print_file(path);
                }
            }
        }

        closedir(dir);
        sleep(1);
    }
}

void clear_ini(const char *dir) {
    char src[PATH_MAX], tmp[PATH_MAX];
    snprintf(src, sizeof(src), "%s/aja.ini", dir);
    snprintf(tmp, sizeof(tmp), "%s/aja.tmp", dir);

    FILE *f = fopen(src, "r"); if (!f) return;
    FILE *out = fopen(tmp, "w"); if (!out) { fclose(f); return; }

    char line[512];
    while (fgets(line, sizeof(line), f)) {
        if (strncmp(line, "start=true", 10) == 0) fputs("start=\r\n", out);
        else if (strncmp(line, "aktivoi=", 8) == 0) fputs("aktivoi=\r\n", out);
        else fputs(line, out);
    }

    fflush(out); fsync(fileno(out));
    fclose(f); fclose(out);
    rename(tmp, src);
}

void execute_command(const char *cmd) {
    DEBUG("🚀 Suoritetaan: %s\n", cmd);
    if (fork() == 0) {
        execlp("sh", "sh", "-c", cmd, (char *)NULL);
        exit(1);
    }
}

void watcher_ini(const char *dir_path) {
    char ini_path[PATH_MAX]; snprintf(ini_path, sizeof(ini_path), "%s/aja.ini", dir_path);
    int detected = 0;

    while (1) {
        FILE *f = fopen(ini_path, "r");
        int start = 0, is_unix = 0;
        char cmd[512] = "", akt[128] = "";

        if (f) {
            char line[512];
            while (fgets(line, sizeof(line), f)) {
                if (strncmp(line, "start=true", 10) == 0) start = 1;
                if (strncmp(line, "system=unix", 11) == 0) is_unix = 1;
                if (strncmp(line, "exe=", 4) == 0) { strncpy(cmd, line + 4, sizeof(cmd)-1); cmd[strcspn(cmd, "\r\n")] = 0; }
                if (strncmp(line, "aktivoi=", 8) == 0) { strncpy(akt, line + 8, sizeof(akt)-1); akt[strcspn(akt, "\r\n")] = 0; }
            }
            fclose(f);
        }

        if (start && is_unix && cmd[0] != '\0') {
            if (!detected) { detected = 1; usleep(100000); continue; }
            clear_ini(dir_path);

            if (strlen(akt)) {
                int found = 0;
                for (int i = 0; i < 20; i++) {
                    char check[256]; snprintf(check, sizeof(check), "wmctrl -l | grep -i \"%s\" > /dev/null", akt);
                    if (system(check) == 0) { found = 1; break; }
                    usleep(100000);
                }
                if (found) {
                    char activate[256]; snprintf(activate, sizeof(activate), "wmctrl -a \"%s\"", akt);
                    DEBUG("🪟 Aktivointi: %s\n", akt);
                    system(activate); detected = 0; continue;
                }
            }

            char *utf8_cmd = ansi_to_utf8(cmd);
            if (utf8_cmd) { execute_command(utf8_cmd); free(utf8_cmd); }
            detected = 0;
            usleep(1000000);
        } else {
            detected = 0;
        }

        usleep(100000);
    }
}

int main(int argc, char *argv[]) {
    if (argc < 2 || argc == 3 || argc > 4) {
        fprintf(stderr, "Käyttö: %s <hakemisto> [-P <kopiomäärä>]\n", argv[0]);
        return 1;
    }

    const char *dir_path = argv[1];
    int copies = 1;
    if (argc == 4 && strcmp(argv[2], "-P") == 0) {
        copies = atoi(argv[3]); if (copies <= 0) copies = 1;
    }

    DEBUG("🌀 LINXPWatcher alkaa (%s), kopiot: %d\n", dir_path, copies);

    if (fork() == 0) { watcher_pdf_and_ps(dir_path, copies); exit(0); }
    if (fork() == 0) { watcher_ini(dir_path); exit(0); }

    DEBUG("✅ Daemonit käynnistetty.\n");
    return 0;
}