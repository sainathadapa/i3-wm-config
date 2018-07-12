#!/bin/sh
sink=`light -G` 
sink=${sink%.*}
if [ $sink -gt 10 ]
then
  light -A 5
else
  light -A 1
fi
sink=`light -G` 
sink=${sink%.*}
notify-send $sink -t 500


