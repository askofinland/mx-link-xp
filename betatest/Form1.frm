VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "MXP server"
   ClientHeight    =   1800
   ClientLeft      =   48
   ClientTop       =   432
   ClientWidth     =   2940
   Icon            =   "Form1.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   1800
   ScaleWidth      =   2940
   StartUpPosition =   3  'Windows Default
   Visible         =   0   'False
   Begin VB.DirListBox homedirri 
      Height          =   504
      Left            =   1080
      TabIndex        =   0
      Top             =   360
      Width           =   1092
   End
   Begin VB.Timer Timer1 
      Interval        =   990
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
Private Declare Sub keybd_event Lib "user32.dll" (ByVal bVk As Byte, ByVal bScan As Byte, ByVal dwFlags As Long, _
ByVal dwExtraInfo As Long)
Dim startdrive$
Dim nochkforstart As Integer
Const VK_STARTKEY = &H5B
Const VK_M = 77
Const KEYEVENTF_KEYUP = &H2

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
homedirri.path = Chr$(f%) + ":\home"
If Err = 0 Then Exit For
Next
For f% = 1 To homedirri.ListCount
a$ = homedirri.path
Err = 0
homedirri.path = homedirri.List(f% - 1) + "\MXP"
If Err = 0 Then Exit For
homedirri.path = a$
Next

For f% = Len(homedirri.path) To 1 Step -1
If Mid$(homedirri.path, f%, 1) = "\" Then
   startdir$ = Left$(homedirri.path, f%) + "ramdisk"
   Exit For
End If
Next
If startdir$ <> "" Then
   c$ = Command$
   dr% = InStr(LCase$(c$), startdrive$)
   If dr% Then
      c$ = Right$(c$, Len(c$) - dr% - 1)
      For f% = 1 To Len(c$)
      If Mid$(c$, f%, 1) = "\" Then Mid$(c$, f%, 1) = "/"
      Next
      If Asc(Right$(c$, 1)) = 34 Then c$ = Chr$(34) + c$
          
   End If
   
End If


End Sub


Private Sub Timer1_Timer()
On Error Resume Next
Dim temppiexe As String
Dim temppipath As String
Dim temppiaktivoi As String
Dim f%

If startdir$ <> "" Then
      If ReadINI("Aja", "system", "", startdir$ + "\aja.ini") = "xp" And ReadINI("Aja", "start", "", startdir$ + "\aja.ini") = "true" Then
         temppiexe = ReadINI("Aja", "exe", "", startdir$ + "\aja.ini")
         If temppiexe <> "" And ReadINI("Aja", "path", "", startdir$ + "\aja.ini") <> "" Then
             temppipath = CurDir$
             ChDrive Left$(ReadINI("Aja", "path", "", startdir$ + "\aja.ini"), 2)
             ChDir ReadINI("Aja", "path", "", startdir$ + "\aja.ini")
             f% = Shell(temppiexe, 1)
             ChDrive Left$(temppipath, 2)
             ChDir temppipath
             WritePrivateProfileString "Aja", "start", "", startdir$ + "\aja.ini"
             WritePrivateProfileString "Aja", "system", "", startdir$ + "\aja.ini"
             WritePrivateProfileString "Aja", "aktivoi", "", startdir$ + "\aja.ini"
             WritePrivateProfileString "Aja", "path", "c:\something", startdir$ + "\aja.ini"


         Else
             If ReadINI("Aja", "aktivoi", "", startdir$ + "\aja.ini") = "hide" Then
                WritePrivateProfileString "Aja", "start", "", startdir$ + "\aja.ini"
                WritePrivateProfileString "Aja", "system", "", startdir$ + "\aja.ini"
                WritePrivateProfileString "Aja", "aktivoi", "", startdir$ + "\aja.ini"
                WritePrivateProfileString "Aja", "path", "c:\something", startdir$ + "\aja.ini"

               'WinKey down
                keybd_event VK_STARTKEY, 0, 0, 0
                'M key down
                keybd_event VK_M, 0, 0, 0
                'M key up
                keybd_event VK_M, 0, KEYEVENTF_KEYUP, 0
                'WinKey up
                 keybd_event VK_STARTKEY, 0, KEYEVENTF_KEYUP, 0
             End If
         End If
  End If
End If


End Sub


