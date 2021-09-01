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
