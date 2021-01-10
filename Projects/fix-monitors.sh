#!/bin/bash

set -x

xrandr --output HDMI-0 --mode 3440x1440 --rate 60

if [ "$1" = "dual" ]; then
	xrandr --output eDP-1-1 --mode 1920x1080 --rate 60 --right-of HDMI-0
else
	xrandr --output eDP-1-1 --off
fi

