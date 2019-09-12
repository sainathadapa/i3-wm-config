#!/bin/sh
brightness=`xbacklight -get intel_backlight` 
brightnessInt=${brightness%.*}
newBrightness=`zenity --scale --value=$brightnessInt`
xbacklight -set $newBrightness intel_backlight
notify-send $newBrightness

