VERSION 5.00
Begin VB.Form Form1 
   BackColor       =   &H00C0FFFF&
   Caption         =   "MX∑link∑XP Setup"
   ClientHeight    =   6420
   ClientLeft      =   48
   ClientTop       =   432
   ClientWidth     =   6792
   BeginProperty Font 
      Name            =   "MS Sans Serif"
      Size            =   9.6
      Charset         =   0
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   LinkTopic       =   "Form1"
   ScaleHeight     =   535
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   566
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton Command2 
      Caption         =   "Install Thunderbird"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.6
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   492
      Left            =   120
      TabIndex        =   10
      Top             =   1560
      Width           =   2772
   End
   Begin VB.Frame Frame2 
      BackColor       =   &H00C0FFFF&
      Caption         =   " Please select the programs you want to install "
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.6
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   3492
      Left            =   120
      TabIndex        =   3
      Top             =   2760
      Width           =   6612
      Begin VB.CheckBox Check1 
         BackColor       =   &H00C0FFFF&
         Caption         =   "Install Calendar Utility"
         Height          =   252
         Index           =   4
         Left            =   240
         TabIndex        =   12
         Top             =   2520
         Value           =   1  'Checked
         Width           =   5772
      End
      Begin VB.CommandButton Command4 
         Caption         =   "Install Server and Utilities"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   9.6
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   492
         Left            =   1560
         TabIndex        =   11
         Top             =   2880
         Width           =   3492
      End
      Begin VB.CheckBox Check1 
         BackColor       =   &H00C0FFFF&
         Caption         =   "CuteWriter PDF printer install"
         Height          =   252
         Index           =   6
         Left            =   240
         TabIndex        =   9
         Top             =   2160
         Value           =   1  'Checked
         Width           =   5772
      End
      Begin VB.CheckBox Check1 
         BackColor       =   &H00C0FFFF&
         Caption         =   "Install Chromium Dock (XP taskbar launcher)"
         Height          =   252
         Index           =   5
         Left            =   240
         TabIndex        =   8
         Top             =   1800
         Value           =   1  'Checked
         Width           =   5772
      End
      Begin VB.CheckBox Check1 
         BackColor       =   &H00C0FFFF&
         Caption         =   "Terminal shortcut"
         Height          =   252
         Index           =   3
         Left            =   240
         TabIndex        =   7
         Top             =   1440
         Value           =   1  'Checked
         Width           =   5772
      End
      Begin VB.CheckBox Check1 
         BackColor       =   &H00C0FFFF&
         Caption         =   "MX File manager shortcut"
         Height          =   252
         Index           =   2
         Left            =   240
         TabIndex        =   6
         Top             =   1080
         Value           =   1  'Checked
         Width           =   5772
      End
      Begin VB.CheckBox Check1 
         BackColor       =   &H00C0FFFF&
         Caption         =   "Google Chrome Dock shortcut"
         Height          =   252
         Index           =   0
         Left            =   240
         TabIndex        =   5
         Top             =   720
         Value           =   1  'Checked
         Width           =   6012
      End
      Begin VB.CheckBox Check1 
         BackColor       =   &H00C0FFFF&
         Caption         =   "MXlinkXP Media Player"
         Height          =   252
         Index           =   1
         Left            =   240
         TabIndex        =   4
         Top             =   360
         Value           =   1  'Checked
         Width           =   6012
      End
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Install Firefox"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.6
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   492
      Left            =   120
      TabIndex        =   2
      Top             =   960
      Width           =   2772
   End
   Begin VB.Frame Frame1 
      BackColor       =   &H00C0FFFF&
      Height          =   732
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   6612
      Begin VB.Label Label1 
         Alignment       =   2  'Center
         BackColor       =   &H00C0FFFF&
         BackStyle       =   0  'Transparent
         Caption         =   "This is the MX∑Link∑XP Installer that installs the XP-side software."
         BeginProperty Font 
            Name            =   "Arial"
            Size            =   10.2
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   -1  'True
            Strikethrough   =   0   'False
         EndProperty
         Height          =   492
         Left            =   120
         TabIndex        =   1
         Top             =   240
         Width           =   6372
      End
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Dim asennusmode%
Dim asennusmaindir As String

Private Declare Function SHGetSpecialFolderPath Lib "shell32.dll" Alias "SHGetSpecialFolderPathA" ( _
    ByVal hwndOwner As Long, _
    ByVal lpszPath As String, _
    ByVal nFolder As Long, _
    ByVal fCreate As Boolean) As Long

Private Const MAX_PATH = 260
Private Const CSIDL_COMMON_PROGRAMS = &H17  ' T‰m‰ on t‰rkein kohta

Private Sub CopyWithCheck(ByVal src As String, ByVal dst As String, ByVal name As String)
    On Error Resume Next
    If Dir(src) = "" Then
        MsgBox name & " not found: " & src, vbExclamation
        Exit Sub
    End If
    If Dir(dst) <> "" Then Kill dst
    FileCopy src, dst
    If Err.Number <> 0 Then
        MsgBox "Failed to install " & name & ".", vbExclamation
    End If
End Sub

Function HaeOhjelmavalikko() As String
    Dim polku As String
    polku = Space$(MAX_PATH)
    If SHGetSpecialFolderPath(0, polku, CSIDL_COMMON_PROGRAMS, False) Then
        HaeOhjelmavalikko = Left$(polku, InStr(polku, vbNullChar) - 1)
        If Right$(HaeOhjelmavalikko, 1) <> "\" Then HaeOhjelmavalikko = HaeOhjelmavalikko & "\"
    Else
        HaeOhjelmavalikko = ""
    End If
End Function

Private Sub Command1_Click()
    Command1.Enabled = False
    Shell Chr$(34) & asennusmaindir & "\Firefox\Firefox Setup 40.0.exe" & Chr$(34), vbNormalFocus

End Sub

Private Sub Command2_Click()
    Command2.Enabled = False
    Shell Chr$(34) & asennusmaindir & "\thunderbird\Thunderbird Setup 1.5.0.14.exe" & Chr$(34), vbNormalFocus

End Sub


Private Sub Command3_Click()

End Sub


Private Sub Command4_Click()
    Dim eifirefoxia As Integer
    Dim eithunderia As Integer
    eifirefoxia = 0
    eithunderia = 0

    Dim firefoxPath As String, thunderbirdPath As String
    firefoxPath = Environ$("ProgramFiles") & "\Mozilla Firefox\firefox.exe"
    thunderbirdPath = Environ$("ProgramFiles") & "\Mozilla Thunderbird\thunderbird.exe"

    ' Tarkistetaan, onko ohjelmat asennettu
    If Dir(firefoxPath) = "" Then
        MsgBox "Firefox is not installed. Please install it first before continuing.", vbExclamation, "Missing Firefox"
        eifirefoxia = 1
    End If

    If Dir(thunderbirdPath) = "" Then
        MsgBox "Thunderbird is not installed. Please install it first before continuing.", vbExclamation, "Missing Thunderbird"
        eithunderia = 1
    End If

    Dim ohjelmavalikko As String
    Dim l‰hde As String, kohde As String
    ohjelmavalikko = HaeOhjelmavalikko()
    If Right$(ohjelmavalikko, 1) <> "\" Then ohjelmavalikko = ohjelmavalikko & "\"

    ' MXlinkXP Media Player
    If Check1(1).Value = 1 Then
        l‰hde = asennusmaindir & "\MediaPlayer\MXXPlayer.exe"
        kohde = ohjelmavalikko & "MXlinkXP Media Player.exe"
        CopyWithCheck l‰hde, kohde, "MXlinkXP Media Player"

        ' Tiedostoassosiaatiot
        Dim tiedostop‰‰tteet As Variant
        Dim p‰‰te As Variant
        tiedostop‰‰tteet = Array(".mp4", ".mp3", ".avi", ".mkv", ".flac", ".wav", ".ogg", ".mov")

        For Each p‰‰te In tiedostop‰‰tteet
            CreateObject("WScript.Shell").RegWrite _
                "HKCR\" & p‰‰te & "\", "MXXPlayer.File", "REG_SZ"
        Next

        ' Luo MXXPlayer.File-tyyppi
        Dim regBase As String
        regBase = "HKCR\MXXPlayer.File\"

        With CreateObject("WScript.Shell")
            .RegWrite regBase, "MXlinkXP Media File", "REG_SZ"
            .RegWrite regBase & "DefaultIcon\", Chr(34) & kohde & Chr(34) & ",0", "REG_SZ"
            .RegWrite regBase & "shell\open\command\", Chr(34) & kohde & Chr(34) & " %1", "REG_SZ"
        End With
    End If

    ' Custom Firefox binary copy
    If eifirefoxia = 0 Then
        l‰hde = asennusmaindir & "\Firefox\Firefox.exe"
        kohde = firefoxPath
        CopyWithCheck l‰hde, kohde, "Firefox"
    End If

    ' Custom Thunderbird binary copy
    If eithunderia = 0 Then
        l‰hde = asennusmaindir & "\thunderbird\thunderbird.exe"
        kohde = thunderbirdPath
        CopyWithCheck l‰hde, kohde, "Thunderbird"
    End If

    ' Google Chrome shortcut
    If Check1(0).Value = 1 Then
        l‰hde = asennusmaindir & "\GoogleChrome\googlechrome.exe"
        kohde = ohjelmavalikko & "Google Chrome.exe"
        CopyWithCheck l‰hde, kohde, "Google Chrome"
    End If

    ' MX File Manager
    If Check1(2).Value = 1 Then
        l‰hde = asennusmaindir & "\Thunar\Thunar.exe"
        kohde = ohjelmavalikko & "MX File Manager.exe"
        CopyWithCheck l‰hde, kohde, "MX File Manager"
    End If

    ' Terminal
    If Check1(3).Value = 1 Then
        l‰hde = asennusmaindir & "\terminaali\Terminal.exe"
        kohde = ohjelmavalikko & "Terminal.exe"
        CopyWithCheck l‰hde, kohde, "Terminal"
    End If

    ' Chromium Dock
    If Check1(5).Value = 1 Then
        l‰hde = asennusmaindir & "\Cromium\Chromium.exe"
        kohde = ohjelmavalikko & "Chromium.exe"
        CopyWithCheck l‰hde, kohde, "Chromium"
    End If

    ' CuteWriter PDF
    If Check1(6).Value = 1 Then
        Shell Chr$(34) & asennusmaindir & "\Utils\CuteWriter30.exe" & Chr$(34), vbNormalFocus
        MsgBox "Complete CuteWriter installation and press OK to continue.", vbInformation
    End If

    ' XPServ startup
    Dim startupFolder As String
    startupFolder = Space(260)
    If SHGetSpecialFolderPath(0, startupFolder, &H7, False) Then
        startupFolder = Left$(startupFolder, InStr(startupFolder, vbNullChar) - 1)
        If Right$(startupFolder, 1) <> "\" Then startupFolder = startupFolder & "\"
        l‰hde = asennusmaindir & "\xpserv\xpserv.exe"
        kohde = startupFolder & "xpserv.exe"
        CopyWithCheck l‰hde, kohde, "XPServ"
    End If

    ' Calendar to Startup (Check1(4))
    If Check1(4).Value = 1 Then
        l‰hde = asennusmaindir & "\Utils\calendar\calendar.exe"
        kohde = startupFolder & "calendar.exe"
        CopyWithCheck l‰hde, kohde, "Calendar Utility"
    End If

    ' Desktop Maker
    Dim deskKohdeDir As String, deskKohdeExe As String
    deskKohdeDir = Environ$("ProgramFiles") & "\Desktop maker\"
    deskKohdeExe = deskKohdeDir & "Desktop maker.exe"
    If Dir(deskKohdeDir, vbDirectory) = "" Then MkDir deskKohdeDir
    l‰hde = asennusmaindir & "\Utils\Desktop maker\Desktop maker.exe"
    CopyWithCheck l‰hde, deskKohdeExe, "Desktop Maker"

    ' COMDLG32.OCX (optional)
    Dim ocxL‰hde As String, ocxKohde As String
    ocxL‰hde = asennusmaindir & "\Utils\Desktop maker\COMDLG32.OCX"
    ocxKohde = Environ$("SystemRoot") & "\System32\COMDLG32.OCX"
    If Dir(ocxKohde) = "" Then
        CopyWithCheck ocxL‰hde, ocxKohde, "COMDLG32.OCX"
    End If

    If MsgBox("Do you want to run Desktop Maker now to create a shortcut to it on your Linux desktop?", _
              vbYesNo + vbQuestion, "Launch Desktop Maker?") = vbYes Then
        Shell Chr$(34) & deskKohdeExe & Chr$(34), vbNormalFocus
    End If

    End
End Sub

Private Sub Form_Load()
Dim f As Integer
asennusmode% = 0
asennusmaindir = Left$(CurDir$, InStr(CurDir$, "\setup") - 1)
If MsgBox("This will install MX∑Link∑XP software from the following directory:" & vbCrLf & _
          asennusmaindir & vbCrLf & vbCrLf & "Do you want to continue?", _
          vbYesNo + vbQuestion, "MX∑Link∑XP Installer") = vbNo Then
    End
End If

    Dim s‰vy As Long
    s‰vy = RGB(230, 255, 255)

    ' Lomakkeen taustav‰ri
    Me.BackColor = s‰vy

    ' Fonttiasetukset
    Me.Font.name = "Tahoma"
    Me.Font.Size = 9

    Dim ctrl As Control
    For Each ctrl In Me.Controls
        On Error Resume Next
        ctrl.BackColor = s‰vy

        ' Aseta fontti kaikille ohjaimille
        ctrl.Font.name = "Tahoma"
        ctrl.Font.Size = 9

        ' Tee painikkeista lihavoituja (esim. "Next")
        If TypeOf ctrl Is CommandButton Then
            ctrl.Font.Bold = True
        End If

        On Error GoTo 0
    Next
End Sub


