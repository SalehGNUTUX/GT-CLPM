#!/bin/bash

set -e

APP=gt-clpm-cli
APPNAME="GT-CLPM-CLI"
VERSION=1.0
APPDIR=GT-CLPM-CLI.AppDir
ICON_NAME=gt-clpm-cli-icon
DESKTOP_FILE=$APPDIR/usr/share/applications/${APP}.desktop
EXECUTABLE=$APPDIR/usr/bin/$APP
LINUXDEPLOY=./linuxdeploy-x86_64.AppImage

if [ ! -f "$LINUXDEPLOY" ]; then
    echo "❌ لم يتم العثور على linuxdeploy. حمّله من:"
    echo "➡ https://github.com/linuxdeploy/linuxdeploy/releases"
    exit 1
fi

chmod +x $LINUXDEPLOY

echo "🔍 التحقق من محتويات $APPDIR..."

[[ -f "$EXECUTABLE" ]] || { echo "❌ الملف التنفيذي غير موجود: $EXECUTABLE"; exit 1; }
[[ -f "$DESKTOP_FILE" ]] || { echo "❌ ملف .desktop غير موجود: $DESKTOP_FILE"; exit 1; }

ICON_PATH="$APPDIR/usr/share/icons/hicolor"
if ! find "$ICON_PATH" -name "${ICON_NAME}.png" | grep -q .; then
    echo "❌ لم يتم العثور على أيقونة باسم: $ICON_NAME.png"
    exit 1
fi

sed -i "s|^Icon=.*$|Icon=${ICON_NAME}|" "$DESKTOP_FILE"

echo "✅ جاهز لتوليد الحزمة..."

ARCH=x86_64 \
$LINUXDEPLOY \
  --appdir $APPDIR \
  --desktop-file $DESKTOP_FILE \
  --icon-file $ICON_PATH/256x256/apps/${ICON_NAME}.png \
  --output appimage

# إعادة التسمية بالشكل التقليدي (x86_64)
mv *.AppImage GT-CLPM-CLI-x86_64.AppImage

echo "🎉 تم توليد GT-CLPM-CLI-x86_64.AppImage بنجاح."
