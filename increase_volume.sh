#!/bin/sh
sink=`pactl list short sinks | grep RUNNING | cut -f1`                                                                                                                    
notify-send "Volume +5%" -t 500
/usr/bin/pactl set-sink-volume $sink '+5%'

