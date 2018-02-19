#!/bin/sh
light -U 5
sink=`light -G` 
notify-send $sink -t 500

