#!/bin/sh

XDG_DATA_HOME="$HOME/.local/share"

xwallpaper --center "$XDG_DATA_HOME/wallpapers/foggy-mountain.jpg"

picom -b &
polybar example &
sxhkd &
clipmenud &
udiskie --no-automount --no-notify --tray &

exec bspwm
