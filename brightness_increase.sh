#!/bin/sh
light -A 5
sink=`light -G`
notify-send $sink -t 500

