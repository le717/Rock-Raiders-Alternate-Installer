@echo off

echo Deleting unnecessary files...
del /F /Q LegoRR.exe LegoRR.icd
del /F /Q Autorun.exe Autorun.inf
del /F /Q Data\Delme.dat Data\cd.key

echo Installing x86 exe...
move EXE\LegoRR.exe .\
move EXE\LegoRR.icd .\

echo Deleting unnecessary folders...
rd /S /Q DirectX6
rd /S /Q Registration
rd /S /Q EXE
