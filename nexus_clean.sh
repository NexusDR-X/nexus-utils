#!/usr/bin/env bash

# Cleans out leftovers from previous Nexus images

AUTOSTART="/etc/xdg/lxsession/LXDE-pi/autostart"

# If there's no xscreensaver app, delete it from autostart
if ! command -v xscreensaver &> /dev/null
then
	sudo sed -i "/^@xscreensaver.*$/d" $AUTOSTART
fi

