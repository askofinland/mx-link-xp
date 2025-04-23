VERSION 5.00
Begin VB.Form Form1 
   BackColor       =   &H00C0FFFF&
   Caption         =   "MX∑link∑XP Setup"
   ClientHeight    =   4584
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
   ScaleHeight     =   382
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   566
   StartUpPosition =   3  'Windows Default
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
      Height          =   2532
      Left            =   120
      TabIndex        =   3
      Top             =   1080
      Width           =   6612
      Begin VB.CheckBox Check1 
         BackColor       =   &H00C0FFFF&
         Caption         =   "CuteWriter PDF printer install"
         Height          =   252
         Index           =   6
         Left            =   240
         TabIndex        =   10
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
         TabIndex        =   9
         Top             =   1800
         Value           =   1  'Checked
         Width           =   5772
      End
      Begin VB.CheckBox Check1 
         BackColor       =   &H00C0FFFF&
         Caption         =   "XP Home - Shortcut for Linux home folder"
         Height          =   252
         Index           =   4
         Left            =   240
         TabIndex        =   8
         Top             =   3120
         Width           =   5772
         Visible         =   0   'False
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
         Caption         =   "VLC File association handler "
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
      Caption         =   "Next"
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
      Left            =   5040
      TabIndex        =   2
      Top             =   3960
      Width           =   1572
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
Private Sub KopioiK‰ynnistykseen()
    On Error Resume Next
    Dim polku As String
    polku = Space$(MAX_PATH)

    If SHGetSpecialFolderPath(0, polku, CSIDL_COMMON_STARTUP, False) Then
        polku = Left$(polku, InStr(polku, vbNullChar) - 1)

        Dim l‰hde As String
        Dim kohde As String

        l‰hde = asennusmaindir & "\xpserv\xpserv.exe"
        kohde = polku & "\xpserv.exe"
Err = 0
        ' Halutessasi ylikirjoituksen esto:
        If Dir(kohde) <> "" Then Kill kohde
        If Err = 75 Then
            MsgBox "XP Serv is currently running. Please close it before continuing the installation.", vbExclamation, "Warning"
            asennusmode% = asennusmode% - 1
 
            Exit Sub
         End If
        FileCopy l‰hde, kohde
    Else
        MsgBox "The startup folder could not be found.", vbExclamation
        asennusmode% = asennusmode% - 1
    End If
End Sub



Private Sub Command1_Click()
    Command1.Enabled = False
    KopioiK‰ynnistykseen

    Dim kohdeKansio As String
    Dim l‰hde As String, kohde As String
    Dim windowsDir As String
    Dim ohjelmavalikko As String

    ' Selvitet‰‰n Windows-hakemisto
    windowsDir = Environ$("WINDIR")
    If Right$(windowsDir, 1) <> "\" Then windowsDir = windowsDir & "\"
    
    ' Selvitet‰‰n Programs-valikko
    ohjelmavalikko = HaeOhjelmavalikko()
    If Right$(ohjelmavalikko, 1) <> "\" Then ohjelmavalikko = ohjelmavalikko & "\"
    
    ' Pikakuvakkeiden luonti
    On Error Resume Next

    If Check1(0).Value = 1 Then
        l‰hde = asennusmaindir & "\GoogleChrome\googlechrome.exe"
        kohde = ohjelmavalikko & "Google Chrome.exe"
        FileCopy l‰hde, kohde
        Check1(0).Enabled = False
    End If

    If Check1(2).Value = 1 Then
        l‰hde = asennusmaindir & "\Thunar\Thunar.exe"
        kohde = ohjelmavalikko & "MX File Manager.exe"
        FileCopy l‰hde, kohde
        Check1(2).Enabled = False
    End If

    If Check1(3).Value = 1 Then
        l‰hde = asennusmaindir & "\terminaali\Terminal.exe"
        kohde = ohjelmavalikko & "Terminal.exe"
        FileCopy l‰hde, kohde
        Check1(3).Enabled = False
    End If

    ' VLC-asennus
    If Check1(1).Value = 1 Then
        Dim vlcInstaller As String
        Dim vlcSourceExe As String
        Dim vlcTargetExe As String

        vlcInstaller = asennusmaindir & "\vlc\vlc-2.0.2-win32.exe"
        vlcSourceExe = asennusmaindir & "\vlc\vlc.exe"
        vlcTargetExe = Environ$("ProgramFiles") & "\VideoLAN\VLC\vlc.exe"

        Shell vlcInstaller, vbNormalFocus
        MsgBox "Please complete VLC installation and press OK when ready.", vbInformation, "Step 3"

        FileCopy vlcSourceExe, vlcTargetExe
        If Dir(vlcTargetExe) <> "" Then
            MsgBox "VLC customized binary installed.", vbInformation, "Step 3 Complete"
            Check1(1).Enabled = False
        Else
            MsgBox "VLC replacement failed. Please copy manually if needed.", vbExclamation, "Warning"
        End If
    End If

    ' Check1(5): Chromium
    If Check1(5).Value = 1 Then
        l‰hde = asennusmaindir & "\Cromium\Chromium.exe"
        kohde = ohjelmavalikko & "Chromium.exe"
        FileCopy l‰hde, kohde
        Check1(6).Enabled = False
    End If

    ' Check1(6): CuteWriter PDF tulostin
    If Check1(6).Value = 1 Then
        Shell Chr$(34) & asennusmaindir & "\Utils\CuteWriter30.exe" & Chr$(34), vbNormalFocus
        MsgBox "Complete the CuteWriter installation and press OK to continue.", vbInformation, "CuteWriter"
        Check1(7).Enabled = False
    End If





    ' Thunderbird
    MsgBox "Thunderbird will now start." & vbCrLf & _
           "IMPORTANT: Do not create an email account." & vbCrLf & _
           "When it starts, set it as the default email application," & vbCrLf & _
           "then close Thunderbird.", _
           vbInformation, "Instructions"

    Shell Chr$(34) + asennusmaindir & "\thunderbird\Thunderbird Setup 1.5.0.14.exe" + Chr$(34), vbNormalFocus
    MsgBox "Press OK once Thunderbird has been closed.", vbInformation, "Continue"

    l‰hde = asennusmaindir & "\thunderbird\thunderbird.exe"
    kohde = ohjelmavalikko & "Thunderbird.exe"
    FileCopy l‰hde, kohde
    If Dir(kohde) <> "" Then
        MsgBox "Thunderbird menu shortcut created.", vbInformation, "Done"
    Else
        MsgBox "Thunderbird copy failed. Please copy manually if needed.", vbExclamation, "Warning"
    End If

    ' Firefox
    MsgBox "Firefox will now start." & vbCrLf & _
           "Please set it as the default browser when prompted," & vbCrLf & _
           "then close the application to continue.", _
           vbInformation, "Instructions"

    Shell Chr$(34) + asennusmaindir & "\Firefox\Firefox Setup 40.0.exe" + Chr$(34), vbNormalFocus
    MsgBox "Press OK once Firefox has been closed.", vbInformation, "Continue"

    l‰hde = asennusmaindir & "\Firefox\Firefox.exe"
    kohde = ohjelmavalikko & "Firefox.exe"
    FileCopy l‰hde, kohde
    If Dir(kohde) <> "" Then
        MsgBox "Firefox menu shortcut created.", vbInformation, "Done"
    Else
        MsgBox "Firefox copy failed. Please copy manually if needed.", vbExclamation, "Warning"
    End If

    ' Desktop Maker
    Dim deskL‰hde As String, deskKohdeDir As String, deskKohdeExe As String
    deskL‰hde = asennusmaindir & "\Utils\Desktop maker\Desktop maker.exe"
    deskKohdeDir = Environ$("ProgramFiles") & "\Desktop maker\"
    deskKohdeExe = deskKohdeDir & "Desktop maker.exe"

    If Dir(deskKohdeDir, vbDirectory) = "" Then MkDir deskKohdeDir
    FileCopy deskL‰hde, deskKohdeExe
    
' ocx
Dim ocxL‰hde As String
Dim ocxKohde As String

ocxL‰hde = asennusmaindir & "\Utils\Desktop maker\COMDLG32.OCX"
ocxKohde = Environ$("SystemRoot") & "\System32\COMDLG32.OCX"

On Error Resume Next
FileCopy ocxL‰hde, ocxKohde


'*****
    
    
    
    If Dir(deskKohdeExe) <> "" And Dir(ocxKohde) <> "" Then
        MsgBox "Desktop Maker will now start. Use it to create a shortcut for itself on the desktop. After that, you can use it to make shortcuts for other programs.", vbInformation, "Desktop Shortcut"
        Shell deskKohdeExe, vbNormalFocus
    Else
        MsgBox "Desktop maker installation failed. Please copy and run manually if needed.", vbExclamation, "Warning"
    End If

    ' xdg-open.exe asennus C:\WINDOWS-hakemistoon
    l‰hde = asennusmaindir & "\xdg-open\xdg-open.exe"
    kohde = windowsDir & "xdg-open.exe"
    FileCopy l‰hde, kohde
    
    Command1.Enabled = True
    MsgBox "XP-side installation is now complete." & vbCrLf & _
       "You may now start using MX∑Link∑XP.", vbInformation, "Installation Complete"
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
    Me.Font.Name = "Tahoma"
    Me.Font.Size = 9

    Dim ctrl As Control
    For Each ctrl In Me.Controls
        On Error Resume Next
        ctrl.BackColor = s‰vy

        ' Aseta fontti kaikille ohjaimille
        ctrl.Font.Name = "Tahoma"
        ctrl.Font.Size = 9

        ' Tee painikkeista lihavoituja (esim. "Next")
        If TypeOf ctrl Is CommandButton Then
            ctrl.Font.Bold = True
        End If

        On Error GoTo 0
    Next
End Sub


