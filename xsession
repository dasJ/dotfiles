#!/bin/sh

[ -f "/usr/bin/setxkbmap" ] && /usr/bin/setxkbmap -option "caps:swapescape" &

for file in `find .config/autostart -executable -type f -or -type l`; do
	$file &
done &

exec /usr/bin/awesome

