#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/inotify.h>
#include <limits.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/stat.h>
#include <X11/Xlib.h>
#include <X11/Xatom.h>
#include <time.h>
#include <ctype.h>

#define FILE_NAME "aja.ini"
#define PDF_FILE "tulosta.pdf"
#define EVENT_SIZE (sizeof(struct inotify_event))
#define BUF_LEN (1024 * (EVENT_SIZE + 16))
#define MAX_TITLE_LEN 1024
#define MAX_LINE_LEN 2048

// 🟢 Haara 3: XP-ikkunavahti

int contains_ignore_case(const char *hay, const char *needle) {
    char h[MAX_TITLE_LEN], n[MAX_TITLE_LEN];
    strncpy(h, hay, MAX_TITLE_LEN);
    strncpy(n, needle, MAX_TITLE_LEN);
    for (int i = 0; h[i]; i++) h[i] = tolower(h[i]);
    for (int i = 0; n[i]; i++) n[i] = tolower(n[i]);
    return strstr(h, n) != NULL;
}

void get_active_window_title(Display *display, char *title, size_t max_len) {
    Window focused;
    int revert;
    Atom net_wm_name = XInternAtom(display, "_NET_WM_NAME", False);

    XGetInputFocus(display, &focused, &revert);
    Atom actual_type;
    int actual_format;
    unsigned long nitems, bytes_after;
    unsigned char *prop = NULL;

    int status = XGetWindowProperty(display, focused, net_wm_name, 0, (~0L), False,
                                    AnyPropertyType, &actual_type, &actual_format,
                                    &nitems, &bytes_after, &prop);
    if (status == Success && prop) {
        strncpy(title, (char *)prop, max_len - 1);
        title[max_len - 1] = '\0';
        XFree(prop);
    } else {
        strcpy(title, "(tuntematon)");
    }
}

int read_aja_ini_start_value(const char *filepath, char *buffer, size_t size) {
    FILE *fp = fopen(filepath, "r");
    if (!fp) return 0;
    int in_aja = 0;
    while (fgets(buffer, size, fp)) {
        if (strncmp(buffer, "[Aja]", 5) == 0) {
            in_aja = 1;
        } else if (in_aja && buffer[0] == '[') {
            break;
        } else if (in_aja && strncmp(buffer, "start=", 6) == 0) {
            char *val = buffer + 6;
            val[strcspn(val, "\r\n")] = 0;
            fclose(fp);
            return (strcasecmp(val, "true") != 0);
        }
    }
    fclose(fp);
    return 1;
}

int update_aja_ini_focus(const char *filepath) {
    FILE *fp = fopen(filepath, "r");
    if (!fp) return 0;

    FILE *tmp = tmpfile();
    if (!tmp) {
        fclose(fp);
        return 0;
    }

    char line[MAX_LINE_LEN];
    int in_aja = 0;
    char saved_path[PATH_MAX] = "";
    int aja_kirjoitettu = 0;

    while (fgets(line, sizeof(line), fp)) {
        if (strncmp(line, "[Aja]", 5) == 0) {
            in_aja = 1;
            aja_kirjoitettu = 1;

            // Lue Aja-osio ja poimi path=
            while (fgets(line, sizeof(line), fp)) {
                if (strncmp(line, "path=", 5) == 0) {
                    strncpy(saved_path, line + 5, sizeof(saved_path) - 1);
                    saved_path[strcspn(saved_path, "\r\n")] = 0;
                } else if (line[0] == '[') {
                    break;  // Uusi osio alkaa
                }
            }

            // Kirjoita uusi Aja-osio
            fputs("[Aja]\r\n", tmp);
            fputs("exe=\r\n", tmp);
            fputs("system=xp\r\n", tmp);
            fputs("aktivoi=hide\r\n", tmp);
            fputs("start=true\r\n", tmp);
            fprintf(tmp, "path=%s\r\n", saved_path);

            // Jos oltiin jo luettu uusi osio rajaava rivi, käsitellään se
            if (line[0] == '[') {
                fputs(line, tmp);
                in_aja = 0;
            }

        } else if (!in_aja) {
            line[strcspn(line, "\r\n")] = 0;
            fprintf(tmp, "%s\r\n", line);
        }
    }

    // Jos Aja-osio puuttui kokonaan, kirjoitetaan se loppuun
    if (!aja_kirjoitettu) {
        fputs("[Aja]\r\n", tmp);
        fputs("exe=\r\n", tmp);
        fputs("system=xp\r\n", tmp);
        fputs("aktivoi=hide\r\n", tmp);
        fputs("start=true\r\n", tmp);
        fprintf(tmp, "path=%s\r\n", saved_path);
    }

    rewind(tmp);
    FILE *out = fopen(filepath, "w");
    if (!out) {
        fclose(fp);
        fclose(tmp);
        return 0;
    }

    while (fgets(line, sizeof(line), tmp)) {
        fputs(line, out);
    }

    fclose(fp);
    fclose(tmp);
    fclose(out);
    return 1;
}

void watch_focus_changes(const char *dir_path) {
    Display *display = XOpenDisplay(NULL);
    if (!display) {
        fprintf(stderr, "Ei voitu avata X-yhteyttä.\n");
        return;
    }

    char inipath[PATH_MAX];
    snprintf(inipath, sizeof(inipath), "%s/aja.ini", dir_path);

    char prev_title[MAX_TITLE_LEN] = "";
    int xpaktiivi = 0;

    while (1) {
        char current_title[MAX_TITLE_LEN];
        get_active_window_title(display, current_title, sizeof(current_title));

        if (strcmp(current_title, prev_title) != 0) {
            int is_now_xpaktiivi = contains_ignore_case(current_title, "xp") &&
                                   contains_ignore_case(current_title, "virtualbox");

            if (xpaktiivi == 1 && is_now_xpaktiivi == 0) {
                if (read_aja_ini_start_value(inipath, current_title, sizeof(current_title))) {
                    update_aja_ini_focus(inipath);
                }
                xpaktiivi = 0;
            } else {
                xpaktiivi = is_now_xpaktiivi;
            }

            strncpy(prev_title, current_title, sizeof(prev_title));
        }

        usleep(500000);
    }

    XCloseDisplay(display);
}

// 🟢 Haara 1 + 2 alla (säilytetty alkuperäisessä muodossaan)

void update_ini_file(const char *dir_path) {
    char file_path[PATH_MAX];
    snprintf(file_path, sizeof(file_path), "%s/%s", dir_path, FILE_NAME);

    FILE *file = fopen(file_path, "r");
    if (!file) return;

    char temp_path[PATH_MAX];
    snprintf(temp_path, sizeof(temp_path), "%s/aja.tmp", dir_path);
    FILE *temp = fopen(temp_path, "w");
    if (!temp) {
        fclose(file);
        return;
    }

    char line[512];
    while (fgets(line, sizeof(line), file)) {
        if (strncmp(line, "start=true", 10) == 0) {
            fprintf(temp, "start=\r\n");
        } else if (strncmp(line, "aktivoi=", 8) == 0) {
            fprintf(temp, "aktivoi=\r\n");
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
        char activate_command[256];
        snprintf(activate_command, sizeof(activate_command), "wmctrl -a \"%s\"", activate_window);
        if (system(activate_command) == 0) {
            update_ini_file(dir_path);
            return;
        }
    }

    if (unix_mode) {
        char *unix_cmd = strstr(cmd, "/unix ");
        if (unix_cmd) unix_cmd += 6;
        else unix_cmd = cmd;

        if (fork() == 0) {
            execlp("sh", "sh", "-c", unix_cmd, (char *)NULL);
            exit(EXIT_FAILURE);
        }
    } else {
        if (fork() == 0) {
            execlp("sh", "sh", "-c", cmd, (char *)NULL);
            exit(EXIT_FAILURE);
        }
    }
}

void process_ini_file(const char *dir_path) {
    char file_path[PATH_MAX];
    snprintf(file_path, sizeof(file_path), "%s/%s", dir_path, FILE_NAME);

    FILE *file = fopen(file_path, "r");
    if (!file) return;

    char line[512], command[512] = "", activate_window[128] = "";
    int start_flag = 0, unix_mode = 0;

    while (fgets(line, sizeof(line), file)) {
        if (strncmp(line, "exe=", 4) == 0) {
            strcpy(command, line + 4);
            command[strcspn(command, "\r\n")] = 0;
        }
        if (strncmp(line, "start=true", 10) == 0) start_flag = 1;
        if (strncmp(line, "system=unix", 11) == 0) unix_mode = 1;
        if (strncmp(line, "aktivoi=", 8) == 0) {
            strcpy(activate_window, line + 8);
            activate_window[strcspn(activate_window, "\r\n")] = 0;
        }
    }
    fclose(file);

    if (start_flag && command[0] != '\0' && unix_mode) {
        update_ini_file(dir_path);
        execute_command(command, unix_mode, activate_window, dir_path);
    }
}

void watch_ini_file(const char *dir_path) {
    int fd = inotify_init();
    int wd = inotify_add_watch(fd, dir_path, IN_MODIFY);

    while (1) {
        char buffer[BUF_LEN];
        int length = read(fd, buffer, BUF_LEN);
        int i = 0;
        while (i < length) {
            struct inotify_event *event = (struct inotify_event *)&buffer[i];
            if (event->len && (event->mask & IN_MODIFY) && strcmp(event->name, FILE_NAME) == 0) {
                process_ini_file(dir_path);
            }
            i += EVENT_SIZE + event->len;
        }
        sleep(1);
    }
    inotify_rm_watch(fd, wd);
    close(fd);
}

void print_if_pdf_is_ready(const char *dir_path) {
    char pdf_path[PATH_MAX];
    snprintf(pdf_path, sizeof(pdf_path), "%s/%s", dir_path, PDF_FILE);

    struct stat file_stat;
    time_t last_checked_time = 0;

    if (stat(pdf_path, &file_stat) != 0) return;

    while (1) {
        if (stat(pdf_path, &file_stat) != 0) return;
        if (file_stat.st_mtime == last_checked_time) break;
        last_checked_time = file_stat.st_mtime;
        sleep(5);
    }

    char print_command[PATH_MAX + 50];
    snprintf(print_command, sizeof(print_command), "env -u DISPLAY lp \"%s\"", pdf_path);
    if (system(print_command) == 0) {
        unlink(pdf_path);
    }
}

void watch_directory(const char *dir_path) {
    int fd = inotify_init();
    int wd = inotify_add_watch(fd, dir_path, IN_CREATE | IN_MODIFY);

    while (1) {
        char buffer[BUF_LEN];
        int length = read(fd, buffer, BUF_LEN);
        int i = 0;
        while (i < length) {
            struct inotify_event *event = (struct inotify_event *)&buffer[i];
            if (event->len && (event->mask & (IN_CREATE | IN_MODIFY)) &&
                strcmp(event->name, PDF_FILE) == 0) {
                print_if_pdf_is_ready(dir_path);
            }
            i += EVENT_SIZE + event->len;
        }
        sleep(1);
    }
    inotify_rm_watch(fd, wd);
    close(fd);
}

// 🔧 Main: kaikki haarat käynnistetään

int main(int argc, char *argv[]) {
    if (argc != 2) {
        fprintf(stderr, "Käyttö: %s <hakemisto>\n", argv[0]);
        exit(EXIT_FAILURE);
    }

    char *dir_path = argv[1];
    if (access(dir_path, F_OK) != 0) {
        perror("Hakemistoa ei löydy");
        exit(EXIT_FAILURE);
    }

    if (fork() > 0) exit(EXIT_SUCCESS);
    setsid();

    process_ini_file(dir_path);

    if (fork() == 0) { watch_ini_file(dir_path); exit(EXIT_SUCCESS); }
    if (fork() == 0) { watch_directory(dir_path); exit(EXIT_SUCCESS); }
    if (fork() == 0) { watch_focus_changes(dir_path); exit(EXIT_SUCCESS); }

    exit(EXIT_SUCCESS);
}
