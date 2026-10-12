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

# runtime libraries: the curated set the build copied into dist/lib (see the build target in build.xml),
# minus macOS-only and superseded JAXB jars, plus the JAXB runtime that Java 11 no longer bundles
for jar in "$ROOT"/dist/lib/*.jar; do
	case "$(basename "$jar")" in
		filebot.jar|ObjCBridge.jar|jaxb-impl.jar|activation.jar) ;;
		*) cp "$jar" "$OUT/lib/" ;;
	esac
done
for name in jaxb-runtime txw2 istack-commons-runtime javax.activation-api; do
	cp "$ROOT/lib/ivy/jar/$name.jar" "$OUT/lib/"
done

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
