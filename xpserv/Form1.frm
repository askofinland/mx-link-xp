VERSION 5.00
Begin VB.Form Form1 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "MXP server"
   ClientHeight    =   1800
   ClientLeft      =   36
   ClientTop       =   420
   ClientWidth     =   2940
   Icon            =   "Form1.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   1800
   ScaleWidth      =   2940
   ShowInTaskbar   =   0   'False
   Visible         =   0   'False
   Begin VB.DirListBox homedirri 
      Height          =   504
      Left            =   1080
      TabIndex        =   0
      Top             =   360
      Width           =   1092
   End
   Begin VB.Timer Timer1 
      Interval        =   500
      Left            =   360
      Top             =   120
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Dim startdir$
Dim oldikkuna$
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
      Private Declare Function FindExecutableA Lib "shell32.dll" _
    (ByVal lpFile As String, ByVal lpDirectory As String, ByVal lpResult As String) As Long

      
      Private Declare Function WritePrivateProfileString Lib "kernel32" Alias "WritePrivateProfileStringA" (ByVal lpApplicationName As String, ByVal lpKeyName As Any, ByVal lpString As Any, ByVal lpFileName As String) As Long
      Private Declare Function GetPrivateProfileString Lib "kernel32" Alias "GetPrivateProfileStringA" (ByVal lpApplicationName As String, ByVal lpKeyName As Any, ByVal lpDefault As String, ByVal lpReturnedString As String, ByVal nSize As Long, ByVal lpFileName As String) As Long
Private Declare Sub keybd_event Lib "user32.dll" (ByVal bVk As Byte, ByVal bScan As Byte, ByVal dwFlags As Long, _
ByVal dwExtraInfo As Long)
Dim startdrive$
Dim nochkforstart As Integer
Const VK_STARTKEY = &H5B
Const VK_M = 77
Const KEYEVENTF_KEYUP = &H2
Private Declare Function MultiByteToWideChar Lib "kernel32" ( _
    ByVal CodePage As Long, ByVal dwFlags As Long, _
    ByVal lpMultiByteStr As Long, ByVal cbMultiByte As Long, _
    ByVal lpWideCharStr As Long, ByVal cchWideChar As Long _
) As Long

Private Declare Function WideCharToMultiByte Lib "kernel32" ( _
    ByVal CodePage As Long, ByVal dwFlags As Long, _
    ByVal lpWideCharStr As Long, ByVal cchWideChar As Long, _
    ByVal lpMultiByteStr As Long, ByVal cbMultiByte As Long, _
    ByVal lpDefaultChar As String, ByVal lpUsedDefaultChar As Long _
) As Long

Public Sub Fix_UTF8_And_Save_As_ANSI(ByVal tiedosto As String)
    Dim f As Integer
    Dim b() As Byte
    Dim wideLen As Long
    Dim wideStr As String
    Dim ansiLen As Long
    Dim ansibuf() As Byte

    ' --- Lue UTF-8 binäärinä ---
    f = FreeFile
    Open tiedosto For Binary As #f
    ReDim b(LOF(f) - 1)
    Get #f, , b
    Close #f

    ' --- UTF-8 ? Unicode (WideChar) ---
    wideLen = MultiByteToWideChar(65001, 0, VarPtr(b(0)), UBound(b) + 1, 0, 0)
    If wideLen = 0 Then Exit Sub

    wideStr = String$(wideLen, vbNullChar)
    MultiByteToWideChar 65001, 0, VarPtr(b(0)), UBound(b) + 1, StrPtr(wideStr), wideLen

    ' --- Unicode ? ANSI / Windows-1252 ---
    ansiLen = WideCharToMultiByte(1252, 0, StrPtr(wideStr), -1, 0, 0, vbNullString, 0)
    If ansiLen = 0 Then Exit Sub

    ReDim ansibuf(ansiLen - 1)
    WideCharToMultiByte 1252, 0, StrPtr(wideStr), -1, VarPtr(ansibuf(0)), ansiLen, vbNullString, 0

    ' --- Kirjoita ANSI-tiedosto ---
    f = FreeFile
    Open tiedosto For Binary As #f
    Put #f, , ansibuf   ' ? Tämä on se korjattu rivi
    Close #f
End Sub
Public Function EtsiExe(ByVal tiedosto As String, ByVal hakemisto As String) As String
    Dim tulos As String * 260
    Dim ret As Long
    Dim tempstr$
    
    
    If InStr(LCase$(tiedosto), ".exe") Then
       EtsiExe = tiedosto
       Exit Function
    End If
    tempstr$ = tiedosto
    ' Käytä FindExecutable
    ret = FindExecutableA(tiedosto, hakemisto, tulos)
Dim f As Integer
    If ret > 32 Then
        tempstr$ = ""
        For f = 1 To Len(Trim$(Left$(tulos, InStr(tulos, vbNullChar) - 1)))
        If Asc(Mid$(Trim$(Left$(tulos, InStr(tulos, vbNullChar) - 1)), f, 1)) <> 0 Then
           tempstr$ = tempstr$ + Mid$(Trim$(Left$(tulos, InStr(tulos, vbNullChar) - 1)), f, 1)
        End If
        Next
        EtsiExe = tempstr$ + " " + Chr$(34) + tiedosto + Chr$(34)
    Else
        EtsiExe = ""
    End If
End Function

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

Private Sub Form_Load()
Dim f%
Dim a$
Dim b$
Dim c$
Dim dr%
Dim startdrive$
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
         WritePrivateProfileString "Aja", "exe", "/usr/bin/XPserver start", startdir$ + "\aja.ini"
         WritePrivateProfileString "Aja", "path", "c:\windows\command", startdir$ + "\aja.ini"
         WritePrivateProfileString "Aja", "start", "true", startdir$ + "\aja.ini"
         WritePrivateProfileString "Aja", "system", "unix", startdir$ + "\aja.ini"
         WritePrivateProfileString "Aja", "aktivoi", "", startdir$ + "\aja.ini"
    End If
End If




End Sub


Private Sub Timer1_Timer()
On Error Resume Next
Dim temppiexe As String
Dim temppipath As String
Dim temppiaktivoi As String
Dim f%
Dim ikkuna$

If startdir$ <> "" Then
      If ReadINI("Aja", "system", "", startdir$ + "\aja.ini") = "xp" And ReadINI("Aja", "start", "", startdir$ + "\aja.ini") = "true" Then
         Call Fix_UTF8_And_Save_As_ANSI(startdir$ + "\aja.ini")
        
         temppiexe = ReadINI("Aja", "exe", "", startdir$ + "\aja.ini")
         If temppiexe <> "" And ReadINI("Aja", "path", "", startdir$ + "\aja.ini") <> "" Then
             temppipath = CurDir$
             ChDrive Left$(ReadINI("Aja", "path", "", startdir$ + "\aja.ini"), 2)
             ChDir ReadINI("Aja", "path", "", startdir$ + "\aja.ini")
             f% = Shell(EtsiExe(temppiexe, CurDir$), 1)
             ChDrive Left$(temppipath, 2)
             ChDir temppipath
             WritePrivateProfileString "Aja", "start", "", startdir$ + "\aja.ini"
             WritePrivateProfileString "Aja", "system", "", startdir$ + "\aja.ini"
             WritePrivateProfileString "Aja", "aktivoi", "", startdir$ + "\aja.ini"
             WritePrivateProfileString "Aja", "path", "c:\something", startdir$ + "\aja.ini"
         Else
             WritePrivateProfileString "Aja", "start", "", startdir$ + "\aja.ini"
             WritePrivateProfileString "Aja", "system", "", startdir$ + "\aja.ini"
             WritePrivateProfileString "Aja", "aktivoi", "", startdir$ + "\aja.ini"
             WritePrivateProfileString "Aja", "path", "c:\something", startdir$ + "\aja.ini"
         End If
      End If
  If ReadINI("XP", "ROOT", "", startdir$ + "\aja.ini") = "" Then
     WritePrivateProfileString "XP", "ROOT", Left$(startdir$, 3), startdir$ + "\aja.ini"
  End If
End If


End Sub


