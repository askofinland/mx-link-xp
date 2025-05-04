#include <windows.h>
#include <shellapi.h>
#include <commctrl.h>
#include "resource.h"  // sis‰lt‰‰ IDI_TRAYICON-m‰‰rittelyn

#define WM_TRAYICON (WM_USER + 1)
int kalenteriX, kalenteriY, kalenteriLeveys, kalenteriKorkeus;

LRESULT CALLBACK WndProc(HWND hwnd, UINT msg, WPARAM wParam, LPARAM lParam);
void AddTrayIcon(HWND hwnd);
void ToggleCalendar(HWND hwnd);

HWND hwndCalendar = NULL;
HINSTANCE hInst;

void LaskeKalenterinPaikka()
{
    int screenWidth = GetSystemMetrics(SM_CXSCREEN);
    int screenHeight = GetSystemMetrics(SM_CYSCREEN);
    int taskbarHeight = 30;

    kalenteriLeveys = 220;
    kalenteriKorkeus = 220;
    kalenteriX = screenWidth - kalenteriLeveys;
    kalenteriY = screenHeight - kalenteriKorkeus - taskbarHeight;
}

void AddTrayIcon(HWND hwnd)
{
    NOTIFYICONDATAA nid;
    ZeroMemory(&nid, sizeof(nid));
    nid.cbSize = sizeof(nid);
    nid.hWnd = hwnd;
    nid.uID = 1;
    nid.uFlags = NIF_MESSAGE | NIF_ICON | NIF_TIP;
    nid.uCallbackMessage = WM_TRAYICON;

    nid.hIcon = LoadIcon(hInst, MAKEINTRESOURCE(IDI_TRAYICON));
    lstrcpyA(nid.szTip, "Tray Kalenteri");

    Shell_NotifyIconA(NIM_ADD, &nid);
}

void ToggleCalendar(HWND hwnd)
{
    LaskeKalenterinPaikka();  // Laske paikka aina ennen kalenterin n‰yttˆ‰

    if (hwndCalendar && IsWindow(hwndCalendar))
    {
        DestroyWindow(hwndCalendar);
        hwndCalendar = NULL;
    }
    else
    {
        hwndCalendar = CreateWindowExA(
            WS_EX_TOPMOST,
            MONTHCAL_CLASS,
            NULL,
            WS_POPUP | WS_BORDER | WS_VISIBLE,
            kalenteriX, kalenteriY, kalenteriLeveys, kalenteriKorkeus,
            hwnd,
            NULL,
            hInst,
            NULL
        );
    }
}

LRESULT CALLBACK WndProc(HWND hwnd, UINT msg, WPARAM wParam, LPARAM lParam)
{
    switch (msg)
    {
    case WM_TRAYICON:
        if (lParam == WM_LBUTTONDOWN)
        {
            ToggleCalendar(hwnd);
        }
        break;

    case WM_DESTROY:
        PostQuitMessage(0);
        break;

    default:
        return DefWindowProcA(hwnd, msg, wParam, lParam);
    }
    return 0;
}

int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nCmdShow)
{
    WNDCLASSA wc;
    HWND hwnd;
    MSG msg;

    LaskeKalenterinPaikka();
    hInst = hInstance;
    InitCommonControls();

    wc.style = CS_HREDRAW | CS_VREDRAW;
    wc.lpfnWndProc = WndProc;
    wc.cbClsExtra = 0;
    wc.cbWndExtra = 0;
    wc.hInstance = hInstance;
    wc.hIcon = LoadIcon(hInst, MAKEINTRESOURCE(IDI_TRAYICON));
    wc.hCursor = LoadCursor(NULL, IDC_ARROW);
    wc.hbrBackground = (HBRUSH)(COLOR_BTNFACE + 1);
    wc.lpszMenuName = NULL;
    wc.lpszClassName = "MyWindowClass";

    RegisterClassA(&wc);

    hwnd = CreateWindowExA(
        0,
        "MyWindowClass",
        "Form1",
        WS_OVERLAPPEDWINDOW,
        CW_USEDEFAULT, CW_USEDEFAULT, 400, 400,
        NULL, NULL, hInstance, NULL
    );

    ShowWindow(hwnd, SW_HIDE);
    UpdateWindow(hwnd);

    AddTrayIcon(hwnd);

    while (GetMessageA(&msg, NULL, 0, 0))
    {
        TranslateMessage(&msg);
        DispatchMessageA(&msg);
    }

    return (int)msg.wParam;
}
