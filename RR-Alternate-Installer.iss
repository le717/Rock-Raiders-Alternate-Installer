;  LEGO Rock Raiders Alternate Installer
;  Created 2013-2019 Triangle717
;  <http://Triangle717.WordPress.com/>
;
;  Contains source code from Grim Fandango Setup
;  Copyright (c) 2007-2008 Bgbennyboy
;  <http://quick.mixnmojo.com/>

; If any version below the specified version is used for compiling,
; this error will be shown.
#if VER < EncodeVer(5, 6, 1)
  #error You must use Inno Setup 5.6.1 or newer to compile this script
#endif

#define MyAppInstallerName "LEGO Rock Raiders Alternate Installer"
#define MyAppInstallerVersion "1.1.1"
#define MyAppName "LEGO Rock Raiders"
#define MyAppVersion "1.0.0.0"
#define MyAppPublisher "Digital Design Interactive"
#define MyAppExeName "LegoRR.exe"

[Setup]
AppID={#MyAppName}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
VersionInfoVersion={#MyAppInstallerVersion}
AppPublisher={#MyAppPublisher}
AppCopyright=(c) 1999 {#MyAppPublisher}
LicenseFile=license.txt

DefaultDirName={pf}\LEGO Media\Games\{#MyAppName}
DefaultGroupName=LEGO Media\{#MyAppName}
AllowNoIcons=yes

SetupIconFile=rockraiders.ico
WizardImageFile=Sidebar.bmp
WizardSmallImageFile=Small-Image.bmp
WizardImageStretch=True
WizardImageBackColor=clBlack

OutputDir=bin
OutputBaseFilename=LEGO-Rock-Raiders-Alternate-Installer-{#MyAppInstallerVersion}

UninstallFilesDir={app}
UninstallDisplayName={#MyAppName}
UninstallDisplayIcon={app}\rockraiders.ico
CreateUninstallRegKey=yes
; This is required so Inno can correctly report the installation size
UninstallDisplaySize=156237824

Compression=lzma2/ultra64
SolidCompression=yes
InternalCompressLevel=ultra
LZMAUseSeparateProcess=yes

PrivilegesRequired=admin
ShowLanguageDialog=no
RestartIfNeededByRun=no

[Languages]
Name: "English"; MessagesFile: "compiler:Default.isl"

[Messages]
English.BeveledLabel={#MyAppInstallerName}

; DiskSpaceMBLabel is overridden in order to report 
; a correct installation size
DiskSpaceMBLabel=At least 149 MB of free disk space is required.

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
Name: "Admin"; Description: "Run {#MyAppName} with Administrator Rights"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "{code:GetSourceDrive}\data1.cab"; DestDir: "{app}"; Flags: external ignoreversion deleteafterinstall skipifsourcedoesntexist
Source: "{code:GetSourceDrive}\data1.hdr"; DestDir: "{app}"; Flags: external ignoreversion deleteafterinstall skipifsourcedoesntexist
Source: "{code:GetSourceDrive}\EXE\LegoRR.exe"; DestDir: "{app}\EXE"; Flags: external ignoreversion skipifsourcedoesntexist
Source: "{code:GetSourceDrive}\EXE\LegoRR.icd"; DestDir: "{app}\EXE"; Flags: external ignoreversion skipifsourcedoesntexist

Source: "Tools\d3drm.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "Tools\CABExtract\i5comp.exe"; DestDir: "{app}"; Flags: deleteafterinstall
Source: "Tools\CABExtract\ZD51145.DLL"; DestDir: "{app}"; Flags: deleteafterinstall
Source: "Tools\post-install.bat"; DestDir: "{app}"; Flags: deleteafterinstall

Source: "rockraiders.ico"; DestDir: "{app}"; Flags: ignoreversion
Source: "license.txt"; DestDir: "{app}"; Flags: ignoreversion
Source: "Readme.txt"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; IconFilename: "{app}\rockraiders.ico"; IconIndex: 0; Comment: "Run {#MyAppName}"
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"; IconFilename: "{app}\rockraiders.ico"; IconIndex: 0; Comment: "Uninstall {#MyAppName}"
Name: "{commondesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; IconFilename: "{app}\rockraiders.ico"; Comment: "Run {#MyAppName}"; Tasks: desktopicon

[Registry]
Root: "HKCU"; Subkey: "Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers"; ValueType: string; ValueName: "{app}\{#MyAppExeName}"; ValueData: "RUNASADMIN"; Flags: uninsdeletevalue; Tasks: Admin

[Run]
Filename: "{app}\i5comp.exe"; Parameters: "x ""{app}\DATA1.CAB"""; Flags: runascurrentuser
Filename: "{app}\post-install.bat"; WorkingDir: "{app}"; Flags: runascurrentuser
Filename: "{app}\{#MyAppExeName}"; Flags: nowait postinstall skipifsilent runascurrentuser; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"

[Dirs]
; Created to ensure the save games are not removed
; (which should never ever happen)
Name: "{app}\Data\Saves"; Flags: uninsneveruninstall

[UninstallDelete]
; Because the files came from a CAB were not installed from [Files],
; this is required to delete them
Type: files; Name: "{app}\*.dat"
Type: files; Name: "{app}\*.exe"
Type: files; Name: "{app}\*.icd"
Type: files; Name: "{app}\*.txt"
Type: files; Name: "{app}\LegoRR0.wad"
Type: files; Name: "{app}\LegoRR1.wad"
Type: filesandordirs; Name: "{app}\Data\AVI"
Type: filesandordirs; Name: "{app}\Data\Sounds"

[Code]
// Pascal script from Bgbennyboy to detect a CD, cleaned up
// and modified to support ANSI and Unicode Inno Setup
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
