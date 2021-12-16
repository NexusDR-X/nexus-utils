#!/usr/bin/env bash

CARD="$(arecord -l | grep "Fe-Pi Audio" | tr -d ':' | cut -d' ' -f2)"
if [[ -n $CARD ]]
then # Fe-Pi card found. Set reasonable mixer values
   echo >&2 "----->  Fe-Pi card found. Set reasonable levels..."
   AMIXER="$(command -v amixer) -q -c $CARD"
   $AMIXER sset Lineout unmute
   declare -A SET
   SET['Capture Volume']="1,1"
   SET['Capture Attenuate Switch (-6dB)']="on"
   SET['Lineout Playback Volume']="31,31"
   SET['PCM Playback Volume']="170,170"
   SET['Capture Mux']="1"
   for K in "${!SET[@]}"
   do
      $AMIXER cset name="$K" ${SET[$K]}
   done
   echo >&2 "----->  Done." 
else
   echo >&2 "----->  WARNING: Fe-Pi card not detected!" 
fi


