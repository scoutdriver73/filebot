@echo off
setlocal

rem FileBot (community build) launcher for Windows.
rem Requires a Java 11 runtime that includes JavaFX, e.g. BellSoft Liberica "Full JRE 11".
rem Set JAVA_HOME to point at it, or make sure its bin folder is on PATH.
rem Run FileBot-debug.cmd instead to see error messages in a console window.

set "APP_DIR=%~dp0"
set "APP_DIR=%APP_DIR:~0,-1%"
set "APP_DATA=%APPDATA%\FileBot-Community"
if not exist "%APP_DATA%\tmp" mkdir "%APP_DATA%\tmp"

set "JAVA_EXE=javaw.exe"
if defined JAVA_HOME set "JAVA_EXE=%JAVA_HOME%\bin\javaw.exe"

start "" "%JAVA_EXE%" ^
 -Dapplication.deployment=msi ^
 -Dapplication.update=skip ^
 -Dapplication.dir="%APP_DATA%" ^
 -Djava.io.tmpdir="%APP_DATA%\tmp" ^
 -Djava.util.prefs.PreferencesFactory=net.filebot.util.prefs.FilePreferencesFactory ^
 -Dnet.filebot.util.prefs.file="%APP_DATA%\prefs.properties" ^
 -Dfile.encoding=UTF-8 ^
 -Dunixfs=false ^
 -DuseNativeShell=false ^
 -DuseExtendedFileAttributes=true ^
 -DuseCreationDate=false ^
 -Djava.net.useSystemProxies=true ^
 -Dnet.filebot.AcoustID.fpcalc="%APP_DIR%\fpcalc.exe" ^
 -Djna.nosys=true ^
 -Djna.nounpack=true ^
 -Djna.library.path="%APP_DIR%" ^
 -Djna.boot.library.path="%APP_DIR%" ^
 -Djava.library.path="%APP_DIR%" ^
 -Djava.util.logging.config.file="%APP_DIR%\logging.properties" ^
 --illegal-access=permit ^
 --add-opens=java.base/java.lang=ALL-UNNAMED ^
 --add-opens=java.base/java.lang.invoke=ALL-UNNAMED ^
 --add-opens=java.base/java.util=ALL-UNNAMED ^
 --add-opens=java.base/java.util.function=ALL-UNNAMED ^
 --add-opens=java.base/java.util.regex=ALL-UNNAMED ^
 --add-opens=java.base/java.io=ALL-UNNAMED ^
 --add-opens=java.base/java.nio.file=ALL-UNNAMED ^
 --add-opens=java.base/java.nio.file.attribute=ALL-UNNAMED ^
 --add-opens=java.base/java.nio.channels=ALL-UNNAMED ^
 --add-opens=java.base/java.nio.charset=ALL-UNNAMED ^
 --add-opens=java.base/java.time=ALL-UNNAMED ^
 --add-opens=java.logging/java.util.logging=ALL-UNNAMED ^
 %JAVA_OPTS% %FILEBOT_OPTS% ^
 -cp "%APP_DIR%\FileBot.jar;%APP_DIR%\lib\*" net.filebot.Main %*
