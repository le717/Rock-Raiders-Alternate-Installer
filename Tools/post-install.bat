@echo off

rem Delete unnecessary files
echo Deleting unnecessary files...
del /F /Q LegoRR.exe LegoRR.icd
del /F /Q Autorun.exe Autorun.inf
del /F /Q Data\Delme.dat Data\cd.key

rem Use the correct exe
echo Installing correct exe...
move EXE\LegoRR.exe .\
move EXE\LegoRR.icd .\

rem Delete unnecessary folders
echo Deleting unnecessary folders...
rd /S /Q DirectX6
rd /S /Q Registration
rd /S /Q EXE
