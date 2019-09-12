#!/bin/sh
sink=`xbacklight -get intel_backlight` 
sink=${sink%.*}
if [ $sink -gt 15 ]
then
  xbacklight -dec 5 intel_backlight
else
  xbacklight -dec 1 intel_backlight
fi
notify-send $sink

