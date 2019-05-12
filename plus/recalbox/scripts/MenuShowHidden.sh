#!/bin/sh
##
 # Batocera.PLUS
 # Ativa e desativa o menu do Batocera
 # Autor: Alexandre Freire dos Santos
 # Email: alexxandre.freire@gmail.com
 ##

if ! [ -f "$HOME/recalbox.conf" ]; then
    exit 1
fi

if [ "$(cat "$HOME/recalbox.conf" | grep system.es.menu=default)" ]; then
    sed -i s/'^system.es.menu=.*/system.es.menu=none/' "$HOME/recalbox.conf" "$HOME/recalbox.conf"
elif [ "$(cat "$HOME/recalbox.conf" | grep system.es.menu=none)" ]; then
    sed -i s/'^system.es.menu=.*/system.es.menu=default/' "$HOME/recalbox.conf" "$HOME/recalbox.conf"
else
    exit 2
fi

if [ "$(cat "$HOME/recalbox.conf" | grep system.emulators.specialkeys=default)" ]; then
    sed -i s/'^system.emulators.specialkeys=.*/system.emulators.specialkeys=none/' "$HOME/recalbox.conf"
elif [ "$(cat "$HOME/recalbox.conf" | grep system.emulators.specialkeys=none)" ]; then
    sed -i s/'^system.emulators.specialkeys=.*/system.emulators.specialkeys=default/' "$HOME/recalbox.conf"
else
    exit 3
fi

sync
sleep 1
reboot &

exit 0
