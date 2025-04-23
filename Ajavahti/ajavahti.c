#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <limits.h>
#include <sys/stat.h>
#include <dirent.h>
#include <time.h>
#include <sys/types.h>

#define DEBUG(...) fprintf(stderr, __VA_ARGS__)

// --- ANSI to UTF-8 Conversion ---
char *ansi_to_utf8(const char *ansi_str) {
    size_t len = strlen(ansi_str);
    size_t maxlen = len * 2 + 1; // worst case all extended chars
    char *utf8 = malloc(maxlen);
    if (!utf8) return NULL;

    unsigned char *src = (unsigned char *)ansi_str;
    char *dst = utf8;

    while (*src) {
        if (*src < 0x80) {
            *dst++ = *src++;
        } else {
            *dst++ = 0xC0 | (*src >> 6);
            *dst++ = 0x80 | (*src & 0x3F);
            src++;
        }
    }
    *dst = '\0';
    return utf8;
}

// --- PDF PRINTER ---

void print_and_delete_pdf(const char *pdf_path) {
    struct stat file_stat;
    if (stat(pdf_path, &file_stat) != 0) {
        return;
    }

    time_t last_mtime = file_stat.st_mtime;

    while (1) {
        sleep(5);
        if (stat(pdf_path, &file_stat) != 0) return;
        if (file_stat.st_mtime == last_mtime) break;
        last_mtime = file_stat.st_mtime;
    }

    char cmd[PATH_MAX + 100];
    snprintf(cmd, sizeof(cmd), "env -u DISPLAY lp \"%s\"", pdf_path);
    DEBUG("Print command: %s\n", cmd);
    if (system(cmd) == 0) {
        unlink(pdf_path);
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

// --- INI HANDLER ---

void clear_ini_file(const char *dir_path) {
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
    while (fgets(line, sizeof(line), file)) {
        if (strncmp(line, "start=true", 10) == 0) {
            fprintf(tmp, "start=\r\n");
        } else if (strncmp(line, "aktivoi=", 8) == 0) {
            fprintf(tmp, "aktivoi=\r\n");
        } else {
            fputs(line, tmp);
        }
    }

    fflush(tmp);
    fsync(fileno(tmp));
    fclose(file);
    fclose(tmp);
    rename(tmp_path, file_path);
}

void execute_command(char *cmd) {
    char *clean_cmd = NULL;
    if ((clean_cmd = strstr(cmd, "start.exe /unix ")) != NULL) {
        clean_cmd += strlen("start.exe /unix ");
    } else if ((clean_cmd = strstr(cmd, "/unix ")) != NULL) {
        clean_cmd += strlen("/unix ");
    } else {
        clean_cmd = cmd;
    }

    DEBUG("Run command: %s\n", clean_cmd);

    if (fork() == 0) {
        execlp("sh", "sh", "-c", clean_cmd, (char *)NULL);
        exit(EXIT_FAILURE);
    }
}

void ini_daemon(const char *dir_path) {
    char ini_path[PATH_MAX];
    snprintf(ini_path, sizeof(ini_path), "%s/aja.ini", dir_path);

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
                if (strncmp(line, "exe=", 4) == 0) {
                    strncpy(cmd, line + 4, sizeof(cmd) - 1);
                    cmd[strcspn(cmd, "\r\n")] = 0;
                }
                if (strncmp(line, "aktivoi=", 8) == 0) {
                    strncpy(akt, line + 8, sizeof(akt) - 1);
                    akt[strcspn(akt, "\r\n")] = 0;
                }
            }
            fclose(f);
        }

        if (start && is_unix && cmd[0] != '\0') {
            if (detected == 0) {
                detected = 1;
                usleep(100000);
                continue;
            }

            clear_ini_file(dir_path);

            int found = 0;
            if (strlen(akt) > 0) {
                for (int i = 0; i < 20; i++) {
                    char check_cmd[256];
                    snprintf(check_cmd, sizeof(check_cmd), "wmctrl -l | grep -i \"%s\" > /dev/null", akt);
                    if (system(check_cmd) == 0) {
                        found = 1;
                        break;
                    }
                    usleep(100000);
                }

                if (found) {
                    char activate_cmd[256];
                    snprintf(activate_cmd, sizeof(activate_cmd), "wmctrl -a \"%s\"", akt);
                    DEBUG("Activate window: %s\n", activate_cmd);
                    system(activate_cmd);
                    detected = 0;
                    continue;
                }
            }

            char *utf8_cmd = ansi_to_utf8(cmd);
            if (utf8_cmd) {
                execute_command(utf8_cmd);
                free(utf8_cmd);
            }
            detected = 0;
            usleep(1000000);
        } else {
            detected = 0;
        }

        usleep(100000);
    }
}

// --- MAIN ---

int main(int argc, char *argv[]) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <directory>\n", argv[0]);
        return 1;
    }

    const char *dir_path = argv[1];

    DEBUG("\xf0\x9f\x8c\x99 LINXPWatcher starting...\n");

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

    DEBUG("\xf0\x9f\x91\x8b Main process exiting, background watchers active.\n");
    return 0;
}
