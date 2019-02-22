#!/bin/sh
brightness=`light -G` 
brightnessInt=${brightness%.*}
newBrightness=`zenity --scale --value=$brightnessInt`
light -S $newBrightness
notify-send $newBrightness

