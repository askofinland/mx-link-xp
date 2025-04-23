VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   2400
   ClientLeft      =   48
   ClientTop       =   432
   ClientWidth     =   3744
   Icon            =   "Form1.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   2400
   ScaleWidth      =   3744
   StartUpPosition =   3  'Windows Default
   Visible         =   0   'False
   Begin VB.DirListBox homedirri 
      Height          =   288
      Left            =   2160
      TabIndex        =   0
      Top             =   480
      Width           =   852
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

Private Declare Function GetVolumeInformation Lib "kernel32" Alias "GetVolumeInformationA" ( _
    ByVal lpRootPathName As String, _
    ByVal lpVolumeNameBuffer As String, _
    ByVal nVolumeNameSize As Long, _
    lpVolumeSerialNumber As Long, _
    lpMaximumComponentLength As Long, _
    lpFileSystemFlags As Long, _
    ByVal lpFileSystemNameBuffer As String, _
    ByVal nFileSystemNameSize As Long) As Long

Function HaeVolumeLabel(ByVal asema As String) As String
    Dim volumeName As String * 256
    Dim serialNumber As Long
    Dim maxComponentLength As Long
    Dim fileSystemFlags As Long
    Dim fileSystemName As String * 256
    Dim tulos As Long

    If Right$(asema, 1) <> "\" Then asema = asema & "\"

    tulos = GetVolumeInformation( _
        asema, _
        volumeName, _
        Len(volumeName), _
        serialNumber, _
        maxComponentLength, _
        fileSystemFlags, _
        fileSystemName, _
        Len(fileSystemName))

    If tulos <> 0 Then
        HaeVolumeLabel = Left$(volumeName, InStr(volumeName, vbNullChar) - 1)
    Else
        HaeVolumeLabel = "(virhe tai ei saatavilla)"
    End If
End Function

Private Sub Form_Load()
Dim f%
Dim a$
Dim b$
Dim c$
Dim dr%
Dim player$
Dim linuxhomedirri$
player$ = "smplayer "
Dim startdrive$
On Error Resume Next
For f% = Asc("a") To Asc("z")
startdrive$ = Chr$(f%) + ":"
Err = 0
homedirri.path = Chr$(f%) + ":\MXP"
If Err = 0 Then Exit For
Next
a$ = HaeVolumeLabel(startdrive$)
For f% = Len(a$) To 1 Step -1
If Mid$(a$, f%, 1) = "_" Or Mid$(a$, f%, 1) = "\" Or Mid$(a$, f%, 1) = "/" Then
   Exit For
End If
Next
linuxhomedirri$ = "/home/" + Right$(a$, Len(a$) - f%)


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
      c$ = linuxhomedirri$ + c$
      If Asc(Right$(c$, 1)) = 34 Then c$ = Chr$(34) + c$
      If InStr(LCase$(c$), ".iso") = 0 Then
         c$ = c$ + " -start 0:00"
      Else
          player$ = "vlc "
     End If
'      MsgBox Asc("ä")
'      End
   End If
   
   If ReadINI("Aja", "start", "", startdir$ + "\aja.ini") = "false" Or ReadINI("Aja", "start", "", startdir$ + "\aja.ini") = "" Then
         WritePrivateProfileString "Aja", "exe", "/usr/bin/" + player$ + c$, startdir$ + "\aja.ini"
         WritePrivateProfileString "Aja", "path", "c:\windows\command", startdir$ + "\aja.ini"
         WritePrivateProfileString "Aja", "start", "true", startdir$ + "\aja.ini"
         WritePrivateProfileString "Aja", "system", "unix", startdir$ + "\aja.ini"
    End If
End If
End
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



