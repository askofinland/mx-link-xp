#include <windows.h>
#include <stdio.h>

char cabFile[] = "Desktop maker.CAB";
char installPath[] = "C:\\Program Files\\Desktop maker";

void ExpandCAB()
{
    char cmd[512];
    wsprintf(cmd, "expand.exe \"%s\" -F:* \"%s\"", cabFile, installPath);
    system(cmd);
}

void RegisterOCX()
{
    char cmd[512];
    wsprintf(cmd, "regsvr32 /s \"%s\\COMDLG32.OCX\"", installPath);
    system(cmd);
}

void ShowFinalMessage(HWND hwnd)
{
    int answer = MessageBox(hwnd,
        "Installation complete. Launch Desktop maker now?",
        "Success",
        MB_YESNO | MB_ICONQUESTION);

    if (answer == IDYES)
    {
        _chdrive(tolower(installPath[0]) - 'a' + 1);
        chdir(installPath);
        WinExec("Desktop maker.exe", SW_SHOWNORMAL);
    }
}

void CreateInstallDir()
{
    CreateDirectory(installPath, NULL);
}

int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance,
    LPSTR lpCmdLine, int nCmdShow)
{
    CreateInstallDir();
    ExpandCAB();
    RegisterOCX();
    ShowFinalMessage(NULL);
    return 0;
}
