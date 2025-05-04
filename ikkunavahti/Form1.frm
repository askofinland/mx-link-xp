VERSION 5.00
Begin VB.Form Form1 
   BackColor       =   &H00000000&
   Caption         =   "ikkunat"
   ClientHeight    =   6264
   ClientLeft      =   48
   ClientTop       =   432
   ClientWidth     =   8892
   LinkTopic       =   "Form1"
   ScaleHeight     =   6264
   ScaleWidth      =   8892
   StartUpPosition =   3  'Windows Default
   Begin VB.TextBox Text2 
      Height          =   372
      Left            =   240
      TabIndex        =   1
      Text            =   "Text2"
      Top             =   3120
      Width           =   8412
   End
   Begin VB.TextBox Text1 
      Height          =   2652
      Left            =   240
      TabIndex        =   0
      Text            =   "Text1"
      Top             =   240
      Width           =   8532
   End
   Begin VB.Timer Timer1 
      Interval        =   500
      Left            =   600
      Top             =   4560
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
Dim oldakt$
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


Private Sub Timer1_Timer()
Dim polku As String
    Dim m‰‰r‰ As Integer
    Dim i As Integer
    Dim rivi As String

    polku = "E:\ramdisk\ikkunavahti.ini"  ' Muuta tarvittaessa oikeaksi poluksi

    If oldakt$ <> LCase$(ReadINI("ikkunat", "aktiivinen", "", polku)) Then
        Text2.Text = LCase$(ReadINI("ikkunat", "aktiivinen", "", polku))
        oldakt$ = Text2.Text
        If InStr(Text2.Text, "xp") = 0 Then
          AppActivate "Program Manager"
        End If

    End If
    
End Sub


