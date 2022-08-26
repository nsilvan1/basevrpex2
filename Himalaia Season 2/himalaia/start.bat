@echo off

echo ===-------------------------------===
echo     Himalaia 2.0
echo     Developed by: Himalaia
echo     Discord: 
echo     Contact: 
echo ===-------------------------------===

pause
start ..\build\FXServer.exe +exec server.cfg +set onesync_population false +set onesync_enableInfinity 1 +set sv_enforceGameBuild 2372
exit