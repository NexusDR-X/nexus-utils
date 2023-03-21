#!/bin/bash

VERSION="1.0.1"

# This script removes the FePi sound card from the PulseAudio configuration in 6.x 
# Raspberry Pi OS. PulseAudio in 6.x kernels cause choppy audio for some reason.

#nexus-updater.sh nexus-audio
for SIDE in left right
do
	echo >&2 "Setting Fldigi $SIDE audio to Port Audio"
	sed -i -e "s/<SIGONRIGHTCHANNEL>.*<\/SIGONRIGHTCHANNEL>/<SIGONRIGHTCHANNEL>0<\/SIGONRIGHTCHANNEL>/" \
	-e "s/<AUDIOIO>.*<\/AUDIOIO>/<AUDIOIO>1<\/AUDIOIO>/" \
	-e "s/<PORTINDEVICE>.*<\/PORTINDEVICE>/<PORTINDEVICE>fepi-capture-$SIDE<\/PORTINDEVICE>/" \
	-e "s/<PORTININDEX>.*<\/PORTININDEX>/<PORTININDEX>-1<\/PORTININDEX>/" \
	-e "s/<PORTOUTDEVICE>.*<\/PORTOUTDEVICE>/<PORTOUTDEVICE>fepi-playback-$SIDE<\/PORTOUTDEVICE>/" \
	-e "s/<PORTOUTINDEX>.*<\/PORTOUTINDEX>/<PORTOUTINDEX>-1<\/PORTOUTINDEX>/" \
	-e "s/<REVERSEAUDIO>.*<\/REVERSEAUDIO>/<REVERSEAUDIO>0<\/REVERSEAUDIO>/" \
	-e "s/<REVERSERXAUDIO>.*<\/REVERSERXAUDIO>/<REVERSERXAUDIO>0<\/REVERSERXAUDIO>/" \
	$HOME/.fldigi-$SIDE/fldigi_def.xml 
	sudo sed -i -e "s/PULSE_SINK=fepi-playback PULSE_SOURCE=fepi-capture//" /usr/share/applications/fldigi-$SIDE.desktop
	sudo sed -i -e "s/PULSE_SINK=fepi-playback PULSE_SOURCE=fepi-capture//" /usr/share/applications/fldigi-$SIDE.template
	echo >&2 "Fldigi $SIDE Done."
	echo >&2 -e "\n=======================================\n"
done
