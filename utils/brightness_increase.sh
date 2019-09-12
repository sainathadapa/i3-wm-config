#!/bin/sh
sink=`xbacklight -get intel_backlight` 
sink=${sink%.*}
if [ $sink -gt 15 ]
then
  xbacklight -inc 5 intel_backlight
else
  xbacklight -inc 1 intel_backlight
fi
notify-send $sink


