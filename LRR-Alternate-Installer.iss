; LEGO Rock Raiders Alternate Installer
; Created 2013-2015 Triangle717
; <http://Triangle717.WordPress.com/>
; Contains source code from Grim Fandango Setup
; Copyright (c) 2007-2008 Bgbennyboy
; <http://quick.mixnmojo.com/>

; If any version below the specified version is used for compiling, 
; this error will be shown.
#if VER < EncodeVer(5, 5, 2)
  #error You must use Inno Setup 5.5.2 or newer to compile this script
#endif

#define MyAppInstallerName "LEGO® Rock Raiders Alternate Installer"
#define MyAppInstallerVersion "1.0.0"
#define MyAppName "LEGO® Rock Raiders "
#define MyAppNameNoR "LEGO Rock Raiders"
#define MyAppVersion "1.0.0.0"
#define MyAppPublisher "LEGO Media"
#define MyAppExeName "LegoRR.exe"

[Setup]
AppID={#MyAppName}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
VersionInfoVersion={#MyAppInstallerVersion}
AppPublisher={#MyAppPublisher}
AppCopyright=(C) 1999 {#MyAppPublisher}
LicenseFile=license.txt
; Start menu/screen and Desktop shortcuts
DefaultDirName={pf}\LEGO Media\Games\{#MyAppNameNoR}
DefaultGroupName=LEGO Media\{#MyAppNameNoR}
AllowNoIcons=yes
; Installer Graphics
SetupIconFile=RRicon5.ico
WizardImageFile=Sidebar.bmp
WizardSmallImageFile=Small-Image.bmp
WizardImageStretch=True
WizardImageBackColor=clBlack
; Location of the compiled Exe
OutputDir=bin
OutputBaseFilename={#MyAppNameNoR} Alternate Installer {#MyAppInstallerVersion}
; Uninstallation stuff
UninstallFilesDir={app}
UninstallDisplayIcon=RRicon5.ico
CreateUninstallRegKey=yes
UninstallDisplayName={#MyAppName}
; This is required so Inno can correctly report the installation size.
UninstallDisplaySize=112820029
; Compression
Compression=lzma2/ultra64
SolidCompression=yes
InternalCompressLevel=ultra
LZMAUseSeparateProcess=yes
; From top to bottom:
; Explicitly set Admin rights, no other languages, do not restart upon finish.
PrivilegesRequired=admin
ShowLanguageDialog=no
RestartIfNeededByRun=no

[Languages]
Name: "English"; MessagesFile: "compiler:Default.isl"

[Messages]
English.BeveledLabel={#MyAppInstallerName}
; WelcomeLabel2 is overridden because I'm unsure if every LEGO Rock Raiders
; disc says version 1.0.0.0 or just mine.
English.WelcomeLabel2=This will install [name] on your computer.%n%nIt is recommended that you close all other applications before continuing.
; DiskSpaceMBLabel is overridden because it reports
; an incorrect installation size.
English.DiskSpaceMBLabel=

[Files]
; Tool needed to extract the CAB
Source: "Tools\CABExtract\i5comp.exe"; DestDir: "{app}"; Flags: deleteafterinstall
Source: "Tools\CABExtract\ZD51145.DLL"; DestDir: "{app}"; Flags: deleteafterinstall
Source: "Tools\post-install.bat"; DestDir: "{app}"; Flags: deleteafterinstall

Source: "RRIcon5.ico"; DestDir: "{app}"; Flags: ignoreversion
Source: "license.txt"; DestDir: "{app}"; Flags: ignoreversion
Source: "Readme.txt"; DestDir: "{app}"; Flags: ignoreversion

Source: "{code:GetSourceDrive}data1.cab"; DestDir: "{app}"; Flags: external ignoreversion deleteafterinstall skipifsourcedoesntexist
Source: "{code:GetSourceDrive}data1.hdr"; DestDir: "{app}"; Flags: external ignoreversion deleteafterinstall skipifsourcedoesntexist
Source: "{code:GetSourceDrive}EXE\LegoRR.exe"; DestDir: "{app}\EXE"; Flags: external ignoreversion skipifsourcedoesntexist
Source: "{code:GetSourceDrive}EXE\LegoRR.icd"; DestDir: "{app}\EXE"; Flags: external ignoreversion skipifsourcedoesntexist
Source: "{code:GetSourceDrive}DirectX6\DirectX6\Directx\D3DRM.DLL"; DestDir: "{app}"; Flags: external ignoreversion

[Icons]
; First and last icons are created only if user choose not to use the videos,
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; IconFilename: "{app}\RRIcon5.ico"; Comment: "Run {#MyAppName}"
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"; IconFilename: "{app}\RRIcon5.ico";
Name: "{commondesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; IconFilename: "{app}\RRIcon5.ico"; Comment: "{#MyAppName}"; Tasks: desktopicon

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
Name: "Admin"; Description: "Run {#MyAppName} with Administrator Rights"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Registry]
Root: "HKCU"; Subkey: "Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers"; ValueType: string; ValueName: "{app}\{#MyAppExeName}"; ValueData: "RUNASADMIN"; Flags: uninsdeletevalue; Tasks: Admin

[Run]
Filename: "{app}\i5comp.exe"; Parameters: "x ""{app}\DATA1.CAB"""; Flags: runascurrentuser
Filename: "{app}\post-install.bat"; WorkingDir: "{app}"
Filename: "{app}\{#MyAppExeName}"; Flags: nowait postinstall skipifsilent runascurrentuser; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"

[Dirs]
; Created to ensure the save games are not removed
; (which should never ever happen).
Name: "{app}\Data\Saves"; Flags: uninsneveruninstall

[UninstallDelete]
; Because the files came from a CAB were not installed from [Files], 
; this is required to delete them.
Type: files; Name: "{app}\*.exe"
Type: files; Name: "{app}\*.icd"
Type: files; Name: "{app}\LegoRR0.wad"
Type: files; Name: "{app}\LegoRR1.wad"
Type: files; Name: "{app}\Readme.txt"

[Code]
// Pascal script from Bgbennyboy to pull files off a CD, greatly trimmed up 
// and modified to support ANSI and Unicode Inno Setup by Triangle717.
var
	SourceDrive: string;

#include "FindDisc.pas"

function GetSourceDrive(Param: String): String;
begin
	Result:=SourceDrive;
end;

procedure InitializeWizard();
begin
	SourceDrive:=GetSourceCdDrive();
end;
