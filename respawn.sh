#!/bin/bash
# This script is a simple respawn daemon for those of us who dont want
# to deal with the /etc/event.d, monit etc...
#
# file: respawn.sh
# usage: /path/respawn.sh [program name] [sleeptime]
#
# the next example will start and respawn a text
# editor after a 5 seconds delay when it closes
# example: /path/respawn.sh gnome-text-editor 5
#
# when the program closes, logger will display a message in a terminal
# and log the message including the programs PID to the syslog service
# (see file /var/log/syslog)


if [ "$1" == "" ] || [ "$2" == "" ]; then
  echo error: not enough parameters given.
  echo usage: respawn.sh [program name] [sleep time]
  exit 1
fi

PNAME=$1
STIME=$2
RESPAWN=false

while true; do
  if [ "$RESPAWN" != "true" ] && ! pgrep "java"
  then
    logger -i -s -t respawn.sh "$PNAME stopped. Restarting in $STIME seconds."
    RESPAWN=true
  elif [ "$RESPAWN" = "true" ]
  then
    $PNAME &
    RESPAWN=false
  fi
  sleep $STIME
done
