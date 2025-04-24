#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#define MAX_LINES 512
#define MAX_LINE_LEN 1024

int main(int argc, char *argv[]) {
    FILE *fp;
    char *lines[MAX_LINES];
    int line_count = 0;
    char buffer[MAX_LINE_LEN];

    if (argc < 2) {
        fprintf(stderr, "Usage: %s file\n", argv[0]);
        return 1;
    }
    const char *linux_path = argv[1];
    const char *home_dir = getenv("HOME");
    if (!home_dir) {
        fprintf(stderr, "HOME environment variable missing!\n");
        return 1;
    }

    char aja_ini_path[MAX_LINE_LEN];
    char root[4] = "";
    char xp_path[MAX_LINE_LEN];
    char exe[MAX_LINE_LEN];
    char *relative, *last_slash;
    int i, j;

    int in_xp = 0, in_aja = 0;
    int aja_start = -1, aja_end = -1;
    int path_line = -1, exe_line = -1, system_line = -1, start_line = -1, aktivoi_line = -1;

    snprintf(aja_ini_path, sizeof(aja_ini_path), "%s/ramdisk/aja.ini", home_dir);

    // Read aja.ini into memory
    fp = fopen(aja_ini_path, "r");
    if (!fp) {
        perror("Failed to open aja.ini");
        return 1;
    }

    while (fgets(buffer, sizeof(buffer), fp) && line_count < MAX_LINES) {
        lines[line_count++] = strdup(buffer);
    }
    fclose(fp);

    // Find [XP] and ROOT=
    for (i = 0; i < line_count; i++) {
        char *line = lines[i];
        if (strncasecmp(line, "[xp]", 4) == 0) {
            in_xp = 1;
        } else if (line[0] == '[') {
            in_xp = 0;
        } else if (in_xp && strcasestr(line, "root")) {
            char *eq = strchr(line, '=');
            if (eq) {
                while (*(++eq) == ' ') {}
                strncpy(root, eq, 3);
                root[3] = '\0';
            }
        }
    }

    if (strlen(root) != 3) {
        printf("XP ROOT path not found\n");
        return 1;
    }

    // Find [Aja] section and keys
    for (i = 0; i < line_count; i++) {
        if (strncasecmp(lines[i], "[Aja]", 5) == 0) {
            aja_start = i;
            for (j = i + 1; j < line_count; j++) {
                if (lines[j][0] == '[') {
                    aja_end = j;
                    break;
                }
                if (strncasecmp(lines[j], "path=", 5) == 0) path_line = j;
                if (strncasecmp(lines[j], "exe=", 4) == 0) exe_line = j;
                if (strncasecmp(lines[j], "system=", 7) == 0) system_line = j;
                if (strncasecmp(lines[j], "start=", 6) == 0) {
                    if (strncasecmp(lines[j] + 6, "true", 4) == 0) {
                        printf("busy\n");
                        return 0;
                    }
                    start_line = j;
                }
                if (strncasecmp(lines[j], "aktivoi=", 8) == 0) aktivoi_line = j;
            }
            if (aja_end == -1) aja_end = line_count;
            break;
        }
    }

    if (aja_start == -1) {
        printf("[Aja] section not found\n");
        return 1;
    }

    // ************** New logic: HOME-relative XP path ***************
    if (strncmp(linux_path, home_dir, strlen(home_dir)) == 0) {
        relative = (char *)linux_path + strlen(home_dir);
        if (*relative == '/') relative++;
    } else {
        fprintf(stderr, "Path is not under $HOME\n");
        return 1;
    }

    snprintf(xp_path, sizeof(xp_path), "%s%s", root, relative);
    for (i = 0; xp_path[i]; i++) {
        if (xp_path[i] == '/') xp_path[i] = '\\';
    }

    last_slash = strrchr(xp_path, '\\');
    if (!last_slash) {
        printf("Invalid path\n");
        return 1;
    }
    strcpy(exe, last_slash + 1);
    *(last_slash + 1) = '\0'; // leave trailing backslash in xp_path

    // ***************************************************************

    if (path_line != -1) {
        snprintf(buffer, sizeof(buffer), "path=%s\r\n", xp_path);
        free(lines[path_line]);
        lines[path_line] = strdup(buffer);
    }
    if (exe_line != -1) {
        snprintf(buffer, sizeof(buffer), "exe=%s\r\n", exe);
        free(lines[exe_line]);
        lines[exe_line] = strdup(buffer);
    }
    if (system_line != -1) {
        free(lines[system_line]);
        lines[system_line] = strdup("system=xp\r\n");
    }
    if (start_line != -1) {
        free(lines[start_line]);
        lines[start_line] = strdup("start=true\r\n");
    }
    if (aktivoi_line != -1) {
        free(lines[aktivoi_line]);
        lines[aktivoi_line] = strdup("aktivoi=\r\n");
    }

    int insert_at = aja_end;
    if (path_line == -1 && line_count < MAX_LINES) {
        snprintf(buffer, sizeof(buffer), "path=%s\r\n", xp_path);
        lines[insert_at++] = strdup(buffer);
        line_count++;
    }
    if (exe_line == -1 && line_count < MAX_LINES) {
        snprintf(buffer, sizeof(buffer), "exe=%s\r\n", exe);
        lines[insert_at++] = strdup(buffer);
        line_count++;
    }
    if (system_line == -1 && line_count < MAX_LINES) {
        lines[insert_at++] = strdup("system=xp\r\n");
        line_count++;
    }
    if (start_line == -1 && line_count < MAX_LINES) {
        lines[insert_at++] = strdup("start=true\r\n");
        line_count++;
    }
    if (aktivoi_line == -1 && line_count < MAX_LINES) {
        lines[insert_at++] = strdup("aktivoi=\r\n");
        line_count++;
    }

    fp = fopen(aja_ini_path, "w");
    if (!fp) {
        perror("Error writing aja.ini");
        return 1;
    }

    for (i = 0; i < line_count; i++) {
        fputs(lines[i], fp);
        free(lines[i]);
    }

    fclose(fp);

    // Focus XP window
    system("wmctrl -a XP");

    return 0;
}
