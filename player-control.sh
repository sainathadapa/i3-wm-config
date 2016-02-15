#!/bin/sh
name="$1"
shift
PATHS="org.mpris.MediaPlayer2.$name /org/mpris/MediaPlayer2"
DBUS_SEND="dbus-send --type=method_call --dest=$PATHS"
RC="$DBUS_SEND org.mpris.MediaPlayer2.Player"
if [ "$@" = "prev" ]; then
    $RC.Previous
elif [ "$@" = "stop" ]; then
    $RC.Pause
elif [ "$@" = "toggle" ]; then
    $RC.PlayPause
elif [ "$@" = "next" ]; then
    $RC.Next
elif [ "$@" = "random" ]; then
    current=$(mdbus2 $PATHS org.freedesktop.DBus.Properties.Get org.mpris.MediaPlayer2.Player Shuffle)
    if [ "$current" = "( true)" ]; then
        other=false
    else
        other=true
    fi
    $DBUS_SEND org.freedesktop.DBus.Properties.Set string:org.mpris.MediaPlayer2.Player string:Shuffle variant:boolean:$other
else
    echo "Command not found for player $name: $@" 1>&2
    exit 1
fi