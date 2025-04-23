#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_LINES 512
#define MAX_LINE_LENGTH 512
#define MAX_KEY_LENGTH 128

// Rakenne avain-arvo-parien tallennukseen
typedef struct {
    char key[MAX_KEY_LENGTH];
    char value[MAX_LINE_LENGTH];
} KeyValue;

int starts_with(const char *line, const char *prefix) {
    return strncmp(line, prefix, strlen(prefix)) == 0;
}

void trim_newlines(char *line) {
    line[strcspn(line, "\r\n")] = 0;
}

void write_with_crlf(FILE *f, const char *line) {
    fprintf(f, "%s\r\n", line);
}

int main(int argc, char *argv[]) {
    if (argc != 3) {
        fprintf(stderr, "Usage: %s <inputfile> <outputfile>\n", argv[0]);
        return 1;
    }

    const char *inputfile = argv[1];
    const char *outputfile = argv[2];

    FILE *fin = fopen(inputfile, "r");
    if (!fin) {
        perror("Error opening input file");
        return 1;
    }

    KeyValue updates[MAX_LINES];
    int update_count = 0;

    char line[MAX_LINE_LENGTH];
    while (fgets(line, sizeof(line), fin)) {
        trim_newlines(line);
        char *eq = strchr(line, '=');
        if (!eq) continue;

        *eq = '\0';
        strncpy(updates[update_count].key, line, MAX_KEY_LENGTH);
        strncpy(updates[update_count].value, eq + 1, MAX_LINE_LENGTH);
        update_count++;
    }
    fclose(fin);

    FILE *fout = fopen(outputfile, "r");
    char original[MAX_LINES][MAX_LINE_LENGTH];
    int original_count = 0;

    if (fout) {
        while (fgets(line, sizeof(line), fout)) {
            trim_newlines(line);
            strncpy(original[original_count++], line, MAX_LINE_LENGTH);
        }
        fclose(fout);
    }

    FILE *foutw = fopen(outputfile, "w");
    if (!foutw) {
        perror("Error writing output file");
        return 1;
    }

    int used[MAX_LINES] = {0};
    for (int i = 0; i < original_count; i++) {
        int replaced = 0;
        for (int j = 0; j < update_count; j++) {
            if (starts_with(original[i], updates[j].key) && original[i][strlen(updates[j].key)] == '=') {
                char newline[MAX_LINE_LENGTH];
                snprintf(newline, sizeof(newline), "%s=%s", updates[j].key, updates[j].value);
                write_with_crlf(foutw, newline);
                used[j] = 1;
                replaced = 1;
                break;
            }
        }
        if (!replaced) {
            write_with_crlf(foutw, original[i]);
        }
    }

    // Lisää uudet avaimet, joita ei vielä ollut
    for (int j = 0; j < update_count; j++) {
        if (!used[j]) {
            char newline[MAX_LINE_LENGTH];
            snprintf(newline, sizeof(newline), "%s=%s", updates[j].key, updates[j].value);
            write_with_crlf(foutw, newline);
        }
    }

    fclose(foutw);
    return 0;
}
