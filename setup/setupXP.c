#include <windows.h>
#include <shlwapi.h>  // PathCombine, PathFileExists
#include <process.h>  // _spawnl
#include <stdio.h>

#pragma comment(lib, "Shlwapi.lib")

char exeDir[MAX_PATH];

// Alustaa exeDir-muuttujan ohjelman sijainnilla
void InitExeDirectory()
{
    GetModuleFileName(NULL, exeDir, MAX_PATH);
    PathRemoveFileSpec(exeDir);
}

// Tarkistaa löytyykö vbrun60.dll Windowsin hakupolulta
BOOL IsVBRUNInstalled()
{
    char sysPath[MAX_PATH];
    GetSystemDirectory(sysPath, MAX_PATH);
    PathAppend(sysPath, "vbrun60.dll");
    return PathFileExists(sysPath);
}

// Suorittaa .exe-tiedoston ja odottaa että se sulkeutuu
void RunAndWait(const char* exeName)
{
    char fullPath[MAX_PATH];
    STARTUPINFO si = { sizeof(si) };
    PROCESS_INFORMATION pi;

    lstrcpy(fullPath, exeDir);
    PathAppend(fullPath, exeName);

    if (CreateProcess(NULL, fullPath, NULL, NULL, FALSE, 0, NULL, NULL, &si, &pi))
    {
        WaitForSingleObject(pi.hProcess, INFINITE);
        CloseHandle(pi.hProcess);
        CloseHandle(pi.hThread);
    }
}

// Suorittaa .exe-tiedoston ilman odottamista
void RunNoWait(const char* exeName)
{
    char fullPath[MAX_PATH];
    lstrcpy(fullPath, exeDir);
    PathAppend(fullPath, exeName);
    WinExec(fullPath, SW_SHOWNORMAL);
}

int WINAPI WinMain(HINSTANCE hInst, HINSTANCE hPrev, LPSTR lpCmdLine, int nCmdShow)
{
    InitExeDirectory();

    if (!IsVBRUNInstalled())
    {
        RunAndWait("vbrun60sp6.exe");
    }

    RunNoWait("setup1.exe");

    return 0;
}
