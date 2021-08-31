:: Pre Nuget Packaging Script
:: 
:: Should be ran after building DeviceInfoFetcher & InMobiSDKUtilsWinRT are built in release with x86 & x64,
:: but before the nuget pack command is ran to finalize the Nuget Package
::
:: USAGE - From the VS 2019 Dev Command Prompt, enter the command: PATH\TO\PreNugetPackage.bat PATH\TO\WINDOWS\SDK\REPO
:: EXAMPLE COMMAND: "PreNugetPackage.bat "C:\Users\Jason C\Desktop\Windows-SDK"


@ECHO Device Info Sample Nuget Pre Packaging Batch Script
@SET VSDevCmdPromptHome=%CD%
@SET RepoPath=%~dp0
@SET DeviceInfoPath=%RepoPath%

@ECHO Prepare DeviceInfo for packaging

@CD %DeviceInfoPath%
@ECHO Clean existing files
@CD bin\Release
DEL /F DeviceInfoFetcher.winmd
DEL /F DeviceInfoFetcher.xml

@CD %DeviceInfoPath%
@ECHO Copy new files from x86 release build
@CD bin\x86\Release
XCOPY DeviceInfoFetcher.winmd ..\..\Release\
XCOPY DeviceInfoFetcher.xml ..\..\Release\

@ECHO Run corflags for DeviceInfoFetcher
@CD %DeviceInfoPath%\bin\Release
corflags.exe DeviceInfoFetcher.winmd -32BITREQ- -32BITPREF-