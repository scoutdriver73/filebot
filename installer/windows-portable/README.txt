FileBot 4.8 community build - portable Windows package
======================================================

1. Install a Java 11 runtime that includes JavaFX, for example
   BellSoft Liberica "Full JRE 11" (Windows x64 MSI). Let the installer
   set JAVA_HOME, or make sure its bin folder is on PATH.

2. Unzip this folder anywhere (for example C:\Tools\FileBot) and run
   FileBot.cmd. If nothing appears, run FileBot-debug.cmd to see errors.

3. Open Settings > Providers and enter your API keys. A free TMDB key is
   enough for movies and TV. TheTVDB, OpenSubtitles, OMDb, AcoustID, AniDB
   and fanart.tv are optional.

Notes
- Settings, cache and history live in %APPDATA%\FileBot-Community, kept
  separate from any older FileBot install.
- MediaInfo.dll (video/audio details such as resolution and codec) is
  included when the build could download it. If it is missing, copy
  MediaInfo.dll from your old FileBot install into this folder.
- For music fingerprinting (AcoustID), put fpcalc.exe from
  https://acoustid.org/chromaprint in this folder.
- FileBot-debug.cmd also works as the command-line interface, e.g.
  FileBot-debug.cmd -version
