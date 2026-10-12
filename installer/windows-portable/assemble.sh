#!/bin/bash
# Assemble a portable Windows x64 folder from an `ant resolve jar` build.
# Usage: installer/windows-portable/assemble.sh [path/to/MediaInfo.dll]
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
SRC="$ROOT/installer/windows-portable"
OUT="$ROOT/dist/FileBot-windows-x64"
MEDIAINFO="${1:-}"

rm -rf "$OUT"
mkdir -p "$OUT/lib"

# application classes
cp "$ROOT/dist/lib/filebot.jar" "$OUT/FileBot.jar"

# runtime libraries: everything Ivy resolved, minus build-only and macOS-only tools
shopt -s nullglob
for jar in "$ROOT"/lib/ivy/jar/*.jar "$ROOT"/lib/ivy/bundle/*.jar; do
	case "$(basename "$jar")" in
		ant-spk.jar|jdeb.jar|ant-junit.jar|junit.jar|hamcrest-core.jar|bcpg*.jar|bcprov*.jar|commons-compress.jar|*-sources.jar|*-javadoc.jar) ;;
		*) cp "$jar" "$OUT/lib/" ;;
	esac
done
cp "$ROOT/lib/jars/simmetrics.jar" "$ROOT/lib/jars/jacksum.jar" "$OUT/lib/"

# native libraries (JNA dispatch and 7-Zip-JBinding) next to the launcher
cp "$ROOT"/lib/native/win32-x64/*.dll "$OUT/"

# MediaInfo, if one was provided
if [ -n "$MEDIAINFO" ] && [ -f "$MEDIAINFO" ]; then
	cp "$MEDIAINFO" "$OUT/MediaInfo.dll"
fi

# launchers with Windows line endings
sed 's/$/\r/' "$SRC/FileBot.cmd" > "$OUT/FileBot.cmd"
sed -e 's/javaw\.exe/java.exe/g' -e 's/^start "" "%JAVA_EXE%"/"%JAVA_EXE%"/' "$SRC/FileBot.cmd" > "$OUT/FileBot-debug.cmd.tmp"
echo 'pause' >> "$OUT/FileBot-debug.cmd.tmp"
sed 's/$/\r/' "$OUT/FileBot-debug.cmd.tmp" > "$OUT/FileBot-debug.cmd"
rm "$OUT/FileBot-debug.cmd.tmp"

sed 's/$/\r/' "$ROOT/installer/msi/logging.properties" > "$OUT/logging.properties"
sed 's/$/\r/' "$SRC/README.txt" > "$OUT/README.txt"

echo "Assembled $OUT:"
ls -la "$OUT"
echo "Libraries: $(ls "$OUT/lib" | wc -l)"
