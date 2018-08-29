#!/bin/sh

set -x
exec > ~/.i3.log 2>&1

# Settings for HiDPI
gsettings set org.gnome.settings-daemon.plugins.xsettings overrides "[{'Gdk/WindowScalingFactor', <2>}, {'Xft/DPI', <192000>} ]"
xrandr --dpi 192

# Keynoard rate
xset r rate 250 40

# Bell off
xset -b

# Add xrdb config
xrdb -merge ~/.Xresources

# Configure keyboard mapping
xmodmap ~/.Xmodmap

# Disable the touch screen
xinput set-prop 12 "Device Enabled" 0

# Start i3
i3
