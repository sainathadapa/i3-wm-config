#!/bin/sh
sink=`pactl list short sinks | grep RUNNING | cut -f1`
/usr/bin/pactl set-sink-volume $sink '+5%'

SINK=$( pactl list short sinks | sed -e 's,^\([0-9][0-9]*\)[^0-9].*,\1,' | head -n 1 )
NOW=$( pactl list sinks | grep '^[[:space:]]Volume:' | head -n $(( $SINK + 1 )) | tail -n 1 | sed -e 's,.* \([0-9][0-9]*\)%.*,\1,' )

notify-send "Volume+ $NOW" -t 500
