@echo off

echo ===-------------------------------===
echo     Cruz Academy FREE (2.0)
echo     Developed by: Cruz
echo     Discord: https://discord.gg/pXX2NeW8Tr
echo     Contact: cruzbases@gmail.com
echo ===-------------------------------===

pause
start ..\build\FXServer.exe +exec server.cfg +set onesync_population false +set onesync_enableInfinity 1 +set sv_enforceGameBuild 2372
exit