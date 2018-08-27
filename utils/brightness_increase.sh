#!/bin/sh
sink=`light -G` 
sink=${sink%.*}
if [ $sink -gt 15 ]
then
  light -A 5
else
  light -A 1
fi
sink=`light -G` 
sink=${sink%.*}
notify-send $sink


