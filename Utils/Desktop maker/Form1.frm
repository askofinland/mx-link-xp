VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Begin VB.Form Form1 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Linux Desktop maker"
   ClientHeight    =   6180
   ClientLeft      =   36
   ClientTop       =   420
   ClientWidth     =   3708
   Icon            =   "Form1.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   6180
   ScaleWidth      =   3708
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.TextBox Text2 
      Height          =   288
      Left            =   1800
      TabIndex        =   11
      Top             =   5040
      Width           =   1812
   End
   Begin MSComDlg.CommonDialog CommonDialog1 
      Left            =   360
      Top             =   5880
      _ExtentX        =   677
      _ExtentY        =   677
      _Version        =   393216
   End
   Begin VB.DirListBox homedirri 
      Height          =   288
      Left            =   120
      TabIndex        =   10
      Top             =   5520
      Width           =   372
      Visible         =   0   'False
   End
   Begin VB.TextBox Text4 
      Enabled         =   0   'False
      Height          =   288
      Left            =   5760
      TabIndex        =   8
      Top             =   5280
      Width           =   2652
   End
   Begin VB.TextBox Text3 
      Enabled         =   0   'False
      Height          =   288
      Left            =   5760
      TabIndex        =   6
      Top             =   4920
      Width           =   2652
   End
   Begin VB.TextBox Text1 
      Height          =   4692
      Left            =   3720
      MultiLine       =   -1  'True
      ScrollBars      =   3  'Both
      TabIndex        =   5
      Top             =   120
      Width           =   6252
   End
   Begin VB.PictureBox Picture1 
      AutoRedraw      =   -1  'True
      AutoSize        =   -1  'True
      BackColor       =   &H00FFFFFF&
      BorderStyle     =   0  'None
      Height          =   400
      Left            =   2880
      ScaleHeight     =   33
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   33
      TabIndex        =   4
      Top             =   5520
      Width           =   400
   End
   Begin VB.FileListBox File1 
      Height          =   1224
      Left            =   120
      Pattern         =   "*.exe"
      TabIndex        =   3
      Top             =   3720
      Width           =   3492
   End
   Begin VB.DirListBox Dir1 
      Height          =   3096
      Left            =   120
      TabIndex        =   2
      Top             =   480
      Width           =   3372
   End
   Begin VB.DriveListBox Drive1 
      Height          =   288
      Left            =   120
      TabIndex        =   1
      Top             =   120
      Width           =   3372
   End
   Begin VB.CommandButton Command2 
      Caption         =   "Make Desktop Shortcut"
      Height          =   372
      Left            =   600
      TabIndex        =   0
      Top             =   5520
      Width           =   2172
   End
   Begin VB.Label Label3 
      Alignment       =   1  'Right Justify
      Caption         =   "Linux Home path:"
      Height          =   252
      Left            =   120
      TabIndex        =   12
      Top             =   5040
      Width           =   1572
   End
   Begin VB.Label Label2 
      Alignment       =   1  'Right Justify
      Caption         =   "Linux XP path: "
      Height          =   252
      Left            =   3720
      TabIndex        =   9
      Top             =   5280
      Width           =   1932
   End
   Begin VB.Label Label1 
      Alignment       =   1  'Right Justify
      Caption         =   "Linux username: "
      Height          =   252
      Left            =   3720
      TabIndex        =   7
      Top             =   4920
      Width           =   1932
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Private Declare Function WritePrivateProfileString Lib "kernel32" Alias "WritePrivateProfileStringA" (ByVal lpApplicationName As String, ByVal lpKeyName As Any, ByVal lpString As Any, ByVal lpFileName As String) As Long

Private Declare Function ExtractIconEx Lib "shell32.dll" Alias "ExtractIconExA" _
    (ByVal lpszFile As String, ByVal nIconIndex As Long, ByRef phiconLarge As Long, _
    ByRef phiconSmall As Long, ByVal nIcons As Long) As Long

Private Declare Function DestroyIcon Lib "user32.dll" (ByVal hIcon As Long) As Long
Private Declare Function DrawIconEx Lib "user32.dll" (ByVal hdc As Long, ByVal xLeft As Long, _
    ByVal yTop As Long, ByVal hIcon As Long, ByVal cxWidth As Long, ByVal cyWidth As Long, _
    ByVal istepIfAniCur As Long, ByVal hbrFlickerFreeDraw As Long, ByVal diFlags As Long) As Long

Private Declare Function OleCreatePictureIndirect Lib "olepro32.dll" _
    (picDesc As PICTDESC, RefIID As Any, ByVal fPictureOwnsHandle As Long, IPic As IPicture) As Long

Private Type PICTDESC
    cbSizeofStruct As Long
    picType As Long
    hIcon As Long
End Type

Const PICTYPE_ICON = 3

Private Declare Function GetFileVersionInfoSize Lib "version.dll" Alias "GetFileVersionInfoSizeA" _
    (ByVal lptstrFilename As String, lpdwHandle As Long) As Long

Private Declare Function GetFileVersionInfo Lib "version.dll" Alias "GetFileVersionInfoA" _
    (ByVal lptstrFilename As String, ByVal dwHandle As Long, ByVal dwLen As Long, lpData As Any) As Long

Private Declare Function VerQueryValue Lib "version.dll" Alias "VerQueryValueA" _
    (pBlock As Any, ByVal lpSubBlock As String, lpBuffer As Any, nVerSize As Long) As Long

Private Declare Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" _
    (Destination As Any, Source As Any, ByVal Length As Long)
Dim ohjelmanNimi As String
Dim bmpPath As String
Dim linuxkotihakemisto As String
Dim startdir$
Dim ramdiskdir As String
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

Public Sub KirjoitaDesktopEntry()

    ' Luo .desktop-muotoilu
    Dim desktopEntry As String
    desktopEntry = ""
    desktopEntry = desktopEntry & "[Desktop Entry]" & vbCrLf
    desktopEntry = desktopEntry & "Version=1.0" & vbCrLf
    desktopEntry = desktopEntry & "Type=Application" & vbCrLf
    desktopEntry = desktopEntry & "Name= iniwriter " & vbCrLf
    desktopEntry = desktopEntry & "Exec=" & vbCrLf
    desktopEntry = desktopEntry & "Icon=" & vbCrLf
    desktopEntry = desktopEntry & "Terminal=false" & vbCrLf
    desktopEntry = desktopEntry & "Categories=Utility;" & vbCrLf
    desktopEntry = desktopEntry & "" & vbCrLf
   

    Text1.Text = desktopEntry
End Sub

Public Function HaeOhjelmanNimi(ByVal exepath As String) As String
    Dim verSize As Long
    Dim verBuffer() As Byte
    Dim lpBuffer As Long
    Dim nVerSize As Long
    Dim progName As String

    ' Hae version tiedon koko
    verSize = GetFileVersionInfoSize(exepath, 0)
    If verSize = 0 Then Exit Function

    ' Luo puskuri version tiedolle
    ReDim verBuffer(verSize) As Byte

    ' Lataa version tiedot
    If GetFileVersionInfo(exepath, 0, verSize, verBuffer(0)) = 0 Then Exit Function

    ' Hae "FileDescription" -tieto
    If VerQueryValue(verBuffer(0), "\StringFileInfo\040904B0\FileDescription", lpBuffer, nVerSize) = 0 Then Exit Function

    ' Kopioi tieto muuttujaan
    progName = Space$(nVerSize)
    CopyMemory ByVal progName, ByVal lpBuffer, nVerSize

    ' Poista ylimääräiset tyhjät merkit ja palauta tulos
    HaeOhjelmanNimi = Trim$(progName)
End Function

Public Sub TallennaKuvaBMP(ByVal PictureBox As PictureBox, ByVal FilePath As String)
    SavePicture PictureBox.Image, FilePath
End Sub
' Piirtää ikonin PictureBoxiin
Public Sub LataaIkoniKuvaan(ByVal exepath As String, ByVal PictureBox As PictureBox)
    Dim hIcon As Long
    
    ' Hae ensimmäinen ikoni .exe-tiedostosta
    If ExtractIconEx(exepath, 0, hIcon, 0, 1) > 0 Then
        If hIcon <> 0 Then
            ' Tyhjennä PictureBox ja aseta AutoRedraw päälle
            PictureBox.Cls
            PictureBox.AutoRedraw = True
            
            ' Piirrä ikoni PictureBoxiin
            DrawIconEx PictureBox.hdc, 0, 0, hIcon, 32, 32, 0, 0, 3
            
            ' Päivitä PictureBox
            PictureBox.Refresh
            
            ' Vapauta ikoni muistista
            DestroyIcon hIcon
        Else
            MsgBox "Ikonia ei voitu hakea!", vbExclamation, "Virhe"
        End If
    Else
        MsgBox "Ikoneita ei löytynyt!", vbExclamation, "Virhe"
    End If
End Sub

' Käynnistä testilataus painikkeella
Private Sub Command1_Click()
End Sub

Private Function IconToPicture(hIcon As Long) As IPicture
    Dim picDesc As PICTDESC
    Dim IID_IPicture As String
    IID_IPicture = "{7BF80980-BF32-101A-8BBB-00AA00300CAB}"

    With picDesc
        .cbSizeofStruct = Len(picDesc)
        .picType = PICTYPE_ICON
        .hIcon = hIcon
    End With
    
    OleCreatePictureIndirect picDesc, IID_IPicture, 1, IconToPicture
End Function

Private Sub Command2_Click()
    Dim bmpPath As String
    Dim iniPath As String
    Dim putsattunimi As String
    Dim f As Integer

    ' Siivotaan tiedostonimi (ei välilyöntiä eikä pisteitä)
    putsattunimi = ""
    For f = 1 To Len(File1.FileName) - 4
        If Mid$(File1.FileName, f, 1) <> " " And Mid$(File1.FileName, f, 1) <> "." Then
            putsattunimi = putsattunimi + Mid$(File1.FileName, f, 1)
        End If
    Next
    putsattunimi = putsattunimi + Right$(File1.FileName, 4)
    bmpPath = startdir$ + "\" + Left$(putsattunimi, Len(putsattunimi) - 4) + ".bmp"
    iniPath = startdir$ + "\" + Left$(putsattunimi, Len(putsattunimi) - 4) + ".ini"
    ' Linux-muotoiset polut .desktop-tiedostoon
    Dim iconLinuxPath As String
    Dim iniLinuxPath As String
    iconLinuxPath = Text2.Text + Right$(Replace(bmpPath, "\", "/"), Len(bmpPath) - 2)
    iniLinuxPath = Text2.Text + Right$(Replace(iniPath, "\", "/"), Len(iniPath) - 2)
    ' Rakennetaan .desktop-tiedoston sisältö
    Dim desktopEntry As String
    desktopEntry = ""
    desktopEntry = desktopEntry & "[Desktop Entry]" & vbCrLf
    desktopEntry = desktopEntry & "Version=1.0" & vbCrLf
    desktopEntry = desktopEntry & "Type=Application" & vbCrLf
    desktopEntry = desktopEntry & "Name=" & ohjelmanNimi & vbCrLf
    desktopEntry = desktopEntry & "Exec=/usr/bin/iniwriter " & iniLinuxPath & " " + Text2.Text & "/ramdisk/aja.ini" & vbCrLf
    desktopEntry = desktopEntry & "Icon=" & iconLinuxPath & vbCrLf
    desktopEntry = desktopEntry & "Terminal=false" & vbCrLf
    desktopEntry = desktopEntry & "Categories=Utility;" & vbCrLf

    Text1.Text = desktopEntry

    ' Kirjoitetaan ini-tiedosto
    WritePrivateProfileString "Aja", "exe", File1.FileName, iniPath
    WritePrivateProfileString "Aja", "path", Dir1.Path, iniPath
    WritePrivateProfileString "Aja", "start", "true", iniPath
    WritePrivateProfileString "Aja", "system", "xp", iniPath

    ' Tallennetaan BMP-kuva
    TallennaKuvaBMP Picture1, bmpPath
Dim tiedostoPolku As String

On Error Resume Next
CommonDialog1.CancelError = True
CommonDialog1.DialogTitle = "Save .desktop File"
CommonDialog1.Filter = "Desktop Files (*.desktop)|*.desktop|All Files (*.*)|*.*"
CommonDialog1.FileName = ohjelmanNimi & ".desktop"
CommonDialog1.ShowSave

If Err.Number = 0 Then
    tiedostoPolku = CommonDialog1.FileName

    Dim g As Integer
    g = FreeFile
    Open tiedostoPolku For Output As #g
    Print #g, Text1.Text
    Close #g

    MsgBox "File saved as: " & tiedostoPolku, vbInformation, "Saved"
Else
    MsgBox "Save cancelled.", vbExclamation, "Cancelled"
End If
End Sub


Private Sub Dir1_Change()
File1.Path = Dir1.Path

End Sub

Private Sub Drive1_Change()
Dir1.Path = Drive1.Drive
End Sub


Private Sub File1_Click()
   ' Tyhjennetään mahdollinen edellinen kuva
    Picture1.Picture = LoadPicture("")

    ' Määritellään polku valittuun .exe-tiedostoon
    Dim exepath As String
    exepath = Dir1.Path & "\" & File1.FileName

    ' Ladataan ikoni näkyviin PictureBoxiin
    LataaIkoniKuvaan exepath, Picture1

    ' Haetaan ohjelman nimi version tiedoista
    Dim temppinimi As String
    Dim f As Integer
    ohjelmanNimi = HaeOhjelmanNimi(exepath)

    ' Siivotaan ohjelmanNimi mahdollisista null-merkeistä
    temppinimi = ""
    For f = 1 To Len(ohjelmanNimi)
        If Asc(Mid$(ohjelmanNimi, f, 1)) <> 0 Then
            temppinimi = temppinimi & Mid$(ohjelmanNimi, f, 1)
        End If
    Next
    ohjelmanNimi = temppinimi
    ' Jos ohjelmanNimi on tyhjä, käytetään tiedostonimeä ilman .exe
If Len(Trim(ohjelmanNimi)) = 0 Then
    ohjelmanNimi = File1.FileName
    If LCase(Right$(ohjelmanNimi, 4)) = ".exe" Then
        ohjelmanNimi = Left$(ohjelmanNimi, Len(ohjelmanNimi) - 4)
    End If
End If


    ' Päivitetään lomakkeen otsikko
    Form1.Caption = "Linux Desktop maker - " & ohjelmanNimi
End Sub

Private Sub Form_Load()
Dim f%
Dim a$
Dim startdrive$
Form1.Caption = "Linux Desktop maker"
On Error Resume Next
For f% = Asc("a") To Asc("z")
startdrive$ = Chr$(f%) + ":"
Err = 0
homedirri.Path = Chr$(f%) + ":\MXP"
If Err = 0 Then Exit For
Next
a$ = HaeVolumeLabel(startdrive$)
For f% = Len(a$) To 1 Step -1
If Mid$(a$, f%, 1) = "_" Or Mid$(a$, f%, 1) = "\" Or Mid$(a$, f%, 1) = "/" Then
   Exit For
End If
Next
Text2.Text = "/home/" + Right$(a$, Len(a$) - f%)
For f% = Len(homedirri.Path) To 1 Step -1
If Mid$(homedirri.Path, f%, 1) = "\" Then
   startdir$ = Left$(homedirri.Path, f%) + "MXP"
   Exit For
End If
Next
ramdiskdir = Left$(startdir$, Len(startdir$) - 4) + "\ramdisk"
Text4.Text = startdir$
Text3.Text = Mid$(startdir$, 9, InStr(startdir$, "MXP") - 10)
'Text4.Text = "E:\home\" + Text3.Text + "\Winemenu\xpstart\"
End Sub


