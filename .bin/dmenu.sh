#!/bin/bash

if [ -f $HOME/.dmenurc ]; then
    . $HOME/.dmenurc
    else
    DMENU="dmenu -i"
fi

file=$XDG_DATA_HOME/uzbl/bookmarks
goto=`awk '{print $1}' $file | $DMENU`
