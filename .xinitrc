#!/bin/sh

XDG_DATA_HOME="$HOME/.local/share"

feh --bg-scale "$XDG_DATA_HOME/wallpapers/foggy-mountain.jpg"

picom -b &
polybar example &
sxhkd &
clipmenud &
udiskie --no-automount --no-notify --tray &

# Make dunst work good
systemctl --user import-environment DISPLAY

xset s off

exec bspwm
