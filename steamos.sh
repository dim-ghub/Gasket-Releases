#!/bin/bash
set -eu

RELEASE_DIR="$HOME/Gasket-Releases"
ASSET_URL="https://github.com/anomalyco/gasket/releases/latest/download/Gasket.AppImage"

mkdir -p "$RELEASE_DIR"
cd "$RELEASE_DIR"

if command -v wget &>/dev/null; then
	wget -q "$ASSET_URL" -O Gasket.AppImage
else
	curl -L "$ASSET_URL" -o Gasket.AppImage
fi

chmod +x Gasket.AppImage
./Gasket.AppImage --appimage-extract >/dev/null 2>&1
rm -f Gasket.AppImage

cd squashfs-root
rm -f gasket.desktop com.gasket.app.svg
rm -rf usr
chmod +x bin/run.sh

echo "Gasket installed to $RELEASE_DIR"
