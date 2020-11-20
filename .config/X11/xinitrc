#!/bin/sh

XDG_DATA_HOME="$HOME/.local/share"
LOCATION="43.6:-79.4"

xwallpaper --center "$XDG_DATA_HOME/wallpapers/foggy-mountain.jpg"

redshift -l $LOCATION &
picom -b &
polybar example &
sxhkd &
clipmenud &
udiskie --no-automount --no-notify --tray &

exec bspwm
