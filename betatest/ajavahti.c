#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <limits.h>
#include <sys/stat.h>
#include <dirent.h>
#include <time.h>
#include <X11/Xlib.h>
#include <X11/Xatom.h>
#include <ctype.h>

#define FILE_NAME "aja.ini"
#define MAX_TITLE_LEN 1024
#define MAX_LINE_LEN 2048

// Debug-tulostus
#define DEBUG(...) fprintf(stderr, __VA_ARGS__)

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

void update_aja_ini_focus(const char *filepath) {
    FILE *fp = fopen(filepath, "r");
    if (!fp) return;

    FILE *tmp = tmpfile();
    if (!tmp) {
        fclose(fp);
        return;
    }

    char line[MAX_LINE_LEN];
    int in_aja = 0;
    char saved_path[PATH_MAX] = "";
    int aja_kirjoitettu = 0;

    DEBUG("📝 Kirjoitetaan XP-komento ini-tiedostoon...\n");

    while (fgets(line, sizeof(line), fp)) {
        if (strncmp(line, "[Aja]", 5) == 0) {
            in_aja = 1;
            aja_kirjoitettu = 1;

            while (fgets(line, sizeof(line), fp)) {
                if (strncmp(line, "path=", 5) == 0) {
                    strncpy(saved_path, line + 5, sizeof(saved_path) - 1);
                    saved_path[strcspn(saved_path, "\r\n")] = 0;
                } else if (line[0] == '[') {
                    break;
                }
            }

            fputs("[Aja]\r\n", tmp);
            fputs("exe=\r\n", tmp);
            fputs("system=xp\r\n", tmp);
            fputs("aktivoi=hide\r\n", tmp);
            fputs("start=true\r\n", tmp);
            fprintf(tmp, "path=%s\r\n", saved_path);

            if (line[0] == '[') {
                fputs(line, tmp);
                in_aja = 0;
            }
        } else if (!in_aja) {
            fprintf(tmp, "%s", line);
        }
    }

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
        return;
    }

    while (fgets(line, sizeof(line), tmp)) {
        fputs(line, out);
    }

    fclose(fp);
    fclose(tmp);
    fclose(out);
}

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
    if (strlen(activate) > 0) {
        char activate_cmd[256];
        snprintf(activate_cmd, sizeof(activate_cmd), "wmctrl -a \"%s\"", activate);
        DEBUG("🖱️ Aktivointi: %s\n", activate_cmd);
        if (system(activate_cmd) == 0) {
            update_ini_file(dir_path);
            return;
        }
    }

    DEBUG("🚀 Suoritetaan: %s\n", cmd);
    if (fork() == 0) {
        execlp("sh", "sh", "-c", cmd, (char *)NULL);
        exit(EXIT_FAILURE);
    }
}

int main(int argc, char *argv[]) {
    if (argc != 2) {
        fprintf(stderr, "Käyttö: %s <hakemisto>\n", argv[0]);
        return 1;
    }

    const char *dir_path = argv[1];
    char ini_path[PATH_MAX];
    snprintf(ini_path, sizeof(ini_path), "%s/aja.ini", dir_path);

    Display *display = XOpenDisplay(NULL);
    if (!display) {
        fprintf(stderr, "❌ X-yhteys epäonnistui.\n");
        return 1;
    }

    int xpaktiivi = 0;
    char win_title[MAX_TITLE_LEN] = "";

    DEBUG("🔁 Ohjelma käynnistetty vakaalla silmukalla.\n");

    while (1) {
        // 1. PDF-skannaus
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

        // 2. Aja.ini käsittely
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
        } else {
            // 3. XP-ikkunan tarkistus
            get_active_window_title(display, win_title, sizeof(win_title));

            int nyt_xp =
                (contains_ignore_case(win_title, "vmware") ||
                 contains_ignore_case(win_title, "virtualbox")) &&
                contains_ignore_case(win_title, "xp");

            if (nyt_xp && !xpaktiivi) {
                DEBUG("🧠 XP-ikkuna havaittu aktiiviseksi.\n");
                xpaktiivi = 1;
            } else if (!nyt_xp && xpaktiivi) {
                DEBUG("📤 XP-ikkuna suljettu -> kirjoitetaan ini.\n");
                update_aja_ini_focus(ini_path);
                xpaktiivi = 0;
            }
        }

        sleep(1);
    }

    XCloseDisplay(display);
    return 0;
}
