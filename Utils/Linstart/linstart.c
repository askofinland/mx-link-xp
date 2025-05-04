#include <windows.h>
#include <stdio.h>
#include <string.h>

int main(void)
{
    char drive[4] = "A:\\";
    char path[MAX_PATH];
    char startdir[MAX_PATH];
    int found = 0;
    char d;
    char c[MAX_PATH];
    char *cmdline;
    char *param;

    cmdline = GetCommandLineA();

    // Hypätään ohjelman nimen yli
    if (*cmdline == '"') {
        cmdline++;
        while (*cmdline && *cmdline != '"') cmdline++;
        if (*cmdline == '"') cmdline++;
    } else {
        while (*cmdline && *cmdline != ' ') cmdline++;
    }

    // Ohitetaan mahdolliset välilyönnit
    while (*cmdline == ' ') cmdline++;

    lstrcpy(c, cmdline); // Nyt c = pelkkä parametri, esim. /usr/bin/thunar

    // Etsi asema, jossa \MXP-hakemisto löytyy
    for (d = 'A'; d <= 'Z'; d++) {
        drive[0] = d;
        lstrcpy(path, drive);
        lstrcat(path, "MXP\\");

        if (GetFileAttributesA(path) != 0xFFFFFFFF) {
            // Löytyi MXP-hakemisto
            lstrcpy(startdir, drive);
            lstrcat(startdir, "ramdisk\\");
            found = 1;
            break;
        }
    }

    if (!found) {
        return 0;
    }

    {
        char ini_path[MAX_PATH];
        char buffer[16];

        lstrcpy(ini_path, startdir);
        lstrcat(ini_path, "aja.ini");

        GetPrivateProfileStringA("Aja", "start", "", buffer, sizeof(buffer), ini_path);

        if (lstrcmpiA(buffer, "false") == 0 || buffer[0] == '\0') {
            WritePrivateProfileStringA("Aja", "exe", c, ini_path);
            WritePrivateProfileStringA("Aja", "path", "c:\\windows\\command", ini_path);
            WritePrivateProfileStringA("Aja", "start", "true", ini_path);
            WritePrivateProfileStringA("Aja", "system", "unix", ini_path);
            WritePrivateProfileStringA("Aja", "aktivoi", "", ini_path);
        }
    }

    return 0;
}
