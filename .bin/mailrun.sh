#!/bin/sh
###Taken from pbrisbin.com:8080/pages/mutt2.html
PID=`pgrep offlineimap`
[[ -n "$PID" ]] && exit 1
offlineimap -o -u Noninteractive.Quiet &>/dev/null &
exit 0
