#!/bin/bash
. /etc/X11/xinit/xinitrc.d/*        # starts up global xinitrc stuff (gtk, etc.)
xcompmgr -cCfF -r 0 -o 100 D 5 &    # causes bad screen tearing with vdpau
nvidia-settings -l                  # load your nvidia settings
eval `cat $HOME/.fehbg` &           # set background
xsetroot -cursor_name left_ptr &    # set mouse pointer theme
xset s 600 600 &                    # put monitor to sleep after 10 minutes
xset b off                          # turn off visual bellsi
urxvtd -q -f -o &                   # start urxvt daemon
autocutsel &

exec ck-launch-session xmonad       # start xmonad with custom keyboard layout
