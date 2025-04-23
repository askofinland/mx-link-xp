VERSION 5.00
Begin VB.Form Form1 
   BackColor       =   &H00000000&
   Caption         =   "Chromium"
   ClientHeight    =   60
   ClientLeft      =   48
   ClientTop       =   432
   ClientWidth     =   1680
   Icon            =   "Form1.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   60
   ScaleWidth      =   1680
   StartUpPosition =   3  'Windows Default
   Begin VB.DirListBox homedirri 
      Height          =   288
      Left            =   1080
      TabIndex        =   0
      Top             =   360
      Width           =   972
      Visible         =   0   'False
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

Option Explicit
Private Declare Sub keybd_event Lib "user32.dll" (ByVal bVk As Byte, ByVal bScan As Byte, ByVal dwFlags As Long, _
ByVal dwExtraInfo As Long)
Dim startdrive$
Dim nochkforstart As Integer
Const VK_STARTKEY = &H5B
Const VK_M = 77
Const KEYEVENTF_KEYUP = &H2

Dim startdir$
      Private Const MAX_PATH = 260


      Private Declare Function GetSystemDirectory Lib "kernel32" Alias _
      "GetSystemDirectoryA" (ByVal lpBuffer As String, _
                             ByVal nSize As Long) As Long

      Private Declare Function ExtractIcon Lib "shell32.dll" Alias _
      "ExtractIconA" (ByVal hInst As Long, _
                      ByVal lpszExeFileName As String, _
                      ByVal nIconIndex As Long) As Long

      Private Declare Function DrawIcon Lib "user32" (ByVal hDC As Long, _
      ByVal X As Long, ByVal Y As Long, ByVal hIcon As Long) As Long

      Dim path$, nIcon As Long
      
      Private Declare Function WritePrivateProfileString Lib "kernel32" Alias "WritePrivateProfileStringA" (ByVal lpApplicationName As String, ByVal lpKeyName As Any, ByVal lpString As Any, ByVal lpFileName As String) As Long
      Private Declare Function GetPrivateProfileString Lib "kernel32" Alias "GetPrivateProfileStringA" (ByVal lpApplicationName As String, ByVal lpKeyName As Any, ByVal lpDefault As String, ByVal lpReturnedString As String, ByVal nSize As Long, ByVal lpFileName As String) As Long

Sub aktivoilinux()
    'WinKey down
    keybd_event VK_STARTKEY, 0, 0, 0
    'M key down
    keybd_event VK_M, 0, 0, 0
    'M key up
    keybd_event VK_M, 0, KEYEVENTF_KEYUP, 0
    'WinKey up
    keybd_event VK_STARTKEY, 0, KEYEVENTF_KEYUP, 0

If startdir$ <> "" Then
   If ReadINI("Aja", "start", "", startdir$ + "\aja.ini") = "false" Or ReadINI("Aja", "start", "", startdir$ + "\aja.ini") = "" Then
         WritePrivateProfileString "Aja", "exe", "start.exe /unix /usr/bin/chromium ", startdir$ + "\aja.ini"
         WritePrivateProfileString "Aja", "path", "c:\windows\command", startdir$ + "\aja.ini"
         WritePrivateProfileString "Aja", "start", "true", startdir$ + "\aja.ini"
         WritePrivateProfileString "Aja", "system", "unix", startdir$ + "\aja.ini"
         WritePrivateProfileString "Aja", "aktivoi", "chromium", startdir$ + "\aja.ini"

    End If
End If
End Sub
Public Function ReadINI(riSection As String, riKey As String, riDefault As String, INIFile)
    Dim sRiBuffer As String
    Dim sRiValue As String
    Dim sRiLong As String
    Rem Dim INIFile As String
    Rem INIFile =
    If Dir(INIFile) <> "" Then
        sRiBuffer = String(255, vbNull)
        sRiLong = GetPrivateProfileString(riSection, riKey, Chr(1), sRiBuffer, 255, INIFile)
        If Left$(sRiBuffer, 1) <> Chr(1) Then
            sRiValue = Left$(sRiBuffer, sRiLong)
            If sRiValue <> "" Then
                ReadINI = sRiValue
            Else
                ReadINI = riDefault
            End If
        Else
            ReadINI = riDefault
        End If
    Else
        ReadINI = riDefault
    End If
End Function


Private Sub Form_Activate()
aktivoilinux
End Sub

Private Sub Form_Load()
Dim f%
Dim a$
Dim b$
    'WinKey down
    keybd_event VK_STARTKEY, 0, 0, 0
    'M key down
    keybd_event VK_M, 0, 0, 0
    'M key up
    keybd_event VK_M, 0, KEYEVENTF_KEYUP, 0
    'WinKey up
    keybd_event VK_STARTKEY, 0, KEYEVENTF_KEYUP, 0

On Error Resume Next
For f% = Asc("a") To Asc("z")
startdrive$ = Chr$(f%) + ":"
Err = 0
homedirri.path = Chr$(f%) + ":\MXP"
If Err = 0 Then Exit For
Next

For f% = Len(homedirri.path) To 1 Step -1
If Mid$(homedirri.path, f%, 1) = "\" Then
   startdir$ = Left$(homedirri.path, f%) + "ramdisk"
   Exit For
End If
Next
If startdir$ <> "" Then
   
   If ReadINI("Aja", "start", "", startdir$ + "\aja.ini") = "false" Or ReadINI("Aja", "start", "", startdir$ + "\aja.ini") = "" Then
         WritePrivateProfileString "Aja", "exe", "/usr/bin/chromium ", startdir$ + "\aja.ini"
         WritePrivateProfileString "Aja", "path", "c:\windows\command", startdir$ + "\aja.ini"
         WritePrivateProfileString "Aja", "start", "true", startdir$ + "\aja.ini"
         WritePrivateProfileString "Aja", "system", "unix", startdir$ + "\aja.ini"
         WritePrivateProfileString "Aja", "aktivoi", "chromium", startdir$ + "\aja.ini"
    End If
    If ReadINI("Chromium", "Lock", "", startdir$ + "\aja.ini") <> "True" Then
         WritePrivateProfileString "Chromium", "Lock", "True", startdir$ + "\aja.ini"
    Else
        End
    End If

End If

End Sub


Private Sub Form_Paint()
aktivoilinux
End Sub


Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
Dim vastaus As Integer
vastaus = MsgBox("Do you want to remove this dock from the panel?", vbYesNo + vbQuestion, "Remove")
If vastaus <> vbYes Then
    ' Käyttäjä valitsi "Ei"
    Cancel = True
Else
         WritePrivateProfileString "Chromium", "Lock", "False", startdir$ + "\aja.ini"
End If
End Sub


Private Sub Timer1_Timer()

End Sub


