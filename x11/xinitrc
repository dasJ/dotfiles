#!/bin/sh

[ -f "/usr/bin/setxkbmap" ] && /usr/bin/setxkbmap -option "caps:swapescape" &

for file in `find .config/autostart -executable -type f -or -type l -executable`; do
	$file &
done &

exec /usr/bin/i3

