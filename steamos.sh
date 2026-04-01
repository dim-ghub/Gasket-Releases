#!/bin/bash
set -eu

INSTALL_DIR="$HOME/.local/share/com.gasket.app"
DESKTOP_DIR="$HOME/.local/share/applications"
ICON_DIR="$HOME/.local/share/icons/hicolor/256x256/apps"
DOWNLOAD_URL="https://github.com/dim-ghub/Gasket-Releases/releases/latest/download/Gasket.AppImage"

mkdir -p "$INSTALL_DIR"
rm -rf "$INSTALL_DIR/squashfs-root"

if command -v wget &>/dev/null; then
	wget -q "$DOWNLOAD_URL" -O "$INSTALL_DIR/Gasket.AppImage"
else
	curl -L "$DOWNLOAD_URL" -o "$INSTALL_DIR/Gasket.AppImage"
fi

chmod +x "$INSTALL_DIR/Gasket.AppImage"
cd "$INSTALL_DIR"
"$INSTALL_DIR/Gasket.AppImage" --appimage-extract >/dev/null 2>&1
rm -f "$INSTALL_DIR/Gasket.AppImage"

cd "$INSTALL_DIR/squashfs-root"
rm -f gasket.desktop com.gasket.app.svg
rm -rf usr
chmod +x bin/run.sh

mkdir -p "$DESKTOP_DIR"
mkdir -p "$ICON_DIR"

cat >"$DESKTOP_DIR/com.gasket.app.desktop" <<DESKTOP
[Desktop Entry]
Name=Gasket
Comment=ilovemesomegames
Exec=$INSTALL_DIR/squashfs-root/bin/run.sh
Path=$INSTALL_DIR/squashfs-root/
Terminal=false
Icon=com.gasket.app
Type=Application
Categories=Utility;
StartupNotify=true
StartupWMClass=com.gasket.app
DESKTOP

cp "$INSTALL_DIR/squashfs-root/bin/assets/com.gasket.app.svg" "$ICON_DIR/com.gasket.app.svg"
chmod +x "$DESKTOP_DIR/com.gasket.app.desktop"

touch "$INSTALL_DIR/.installed"
update-desktop-database "$DESKTOP_DIR" 2>/dev/null || true

echo "Gasket installed to $INSTALL_DIR"
echo "Desktop entry created. You can now find Gasket in your applications menu."
