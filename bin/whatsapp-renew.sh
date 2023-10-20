#!/usr/bin/env bash

set -e -u -o pipefail

echo nvm use stable

tmpdir="$(mktemp -d)"

wget https://userstyles.org/styles/userjs/142096/dark-whatsapp-by-vednoc.user.js -O ${tmpdir}/dark-whatsapp-by-vednoc.user.js
wget https://raw.githubusercontent.com/DocBox12/WhatsApp-nativefier-fix/master/whatsapp_fix.js -O ${tmpdir}/whatsapp_fix.js

cat "${tmpdir}"/*.js > /tmp/whatsapp_inject.js

nativefier -n "whatsapp" \
    --inject /tmp/whatsapp_inject.js \
    --tray --title-bar-style hidden \
    -u "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.0.0 Safari/537.36" \
    --width 600 --height 400 \
    --single-instance https://web.whatsapp.com/ \
    nativefier-apps/

if [ ! -f  ~/.local/share/applications/WhatsApp.desktop ]; then
    # https://github.com/jiahaog/nativefier/issues/204
    mkdir -p  ~/.local/share/applications
cat <<EOF > ~/.local/share/applications/WhatsApp.desktop
[Desktop Entry]
Type=Application
Encoding=UTF-8
Name=WhatsApp
Comment=WhatsApp (nativefier)
Exec=env FIREFOX_PROFILE=keymon $HOME/nativefier-apps/whatsapp-linux-x64/whatsapp
Icon=$HOME/nativefier-apps/whatsapp-linux-x64/resources/app/icon.png
Terminal=false
EOF
    chmod +x  ~/.local/share/applications/WhatsApp.desktop
    update-desktop-database ~/.local/share/applications/
fi
