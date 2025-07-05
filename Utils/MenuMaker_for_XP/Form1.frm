VERSION 5.00
Begin VB.Form Form1 
   BackColor       =   &H00000000&
   Caption         =   "Thunar"
   ClientHeight    =   396
   ClientLeft      =   48
   ClientTop       =   432
   ClientWidth     =   1680
   LinkTopic       =   "Form1"
   ScaleHeight     =   396
   ScaleWidth      =   1680
   StartUpPosition =   3  'Windows Default
   Begin VB.DirListBox homedirri 
      Height          =   504
      Left            =   480
      TabIndex        =   0
      Top             =   840
      Width           =   732
      Visible         =   0   'False
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Dim startdir$
Dim estoaika As Double
Private Declare Sub keybd_event Lib "user32.dll" (ByVal bVk As Byte, ByVal bScan As Byte, ByVal dwFlags As Long, _
ByVal dwExtraInfo As Long)
Dim startdrive$
Dim nochkforstart As Integer
Const VK_STARTKEY = &H5B
Const VK_M = 77
Const KEYEVENTF_KEYUP = &H2

      
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
Dim commi$

Rem commi$ = "/usr/bin/thunar"
commi$ = Command$

If commi$ = "" Then MsgBox "Parametri puuttuu": End
On Error Resume Next
For f% = Asc("a") To Asc("z")
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
         WritePrivateProfileString "Aja", "exe", commi$, startdir$ + "\aja.ini"
         WritePrivateProfileString "Aja", "path", "c:\windows\command", startdir$ + "\aja.ini"
         WritePrivateProfileString "Aja", "start", "true", startdir$ + "\aja.ini"
         WritePrivateProfileString "Aja", "system", "unix", startdir$ + "\aja.ini"
         WritePrivateProfileString "Aja", "aktivoi", "", startdir$ + "\aja.ini"

    End If
End If
End
End Sub


