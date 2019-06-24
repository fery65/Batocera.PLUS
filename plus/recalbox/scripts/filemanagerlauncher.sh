#!/bin/bash
mouse-pointer on

export XDG_MENU_PREFIX=batocera-
export XDG_CONFIG_DIRS=/etc/xdg

DISPLAY=:0.0 pcmanfm /userdata

mouse-pointer off