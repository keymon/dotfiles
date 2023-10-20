#!/bin/bash

set -o pipefail -e -u

other_display="$(xrandr -q | sed -n 's/^\([a-zA-Z0-9-]*\) connected .*/\1/p' |grep -v eDP-1)"
if [ -n "${other_display:-}" ] ; then
    echo "Cannot find other screen "
fi

echo "Detected monitor ${other_display}"

xrandr \
    --output eDP-1 \
    --primary --mode 2560x1440 \
    --pos 0x1440 \
    --rotate normal \
    --output "${other_display}" \
    --mode 2560x1440 \
    --pos 0x0 \
    --rotate normal

gsettings set org.gnome.settings-daemon.plugins.xsettings overrides "[{'Gdk/WindowScalingFactor', <1>}]"
gsettings set org.gnome.desktop.interface scaling-factor 1
gsettings set org.gnome.desktop.interface text-scaling-factor 1.5


