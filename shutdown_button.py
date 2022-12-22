#!/usr/bin/python3                 

# Version 2.1.2
# Original script by Stewart C. Russell via https://github.com/scruss/shutdown_button
# Modified by Steve Magnuson, AG7GN to control LED on different GPIO during Button
# press.
# Modified 28 October 2022 by AG7GN to pulse heartbeat (blink LED)
# Modified 11 December 2022 by AG7GN to increase default heartbeat interval to 2 sec.
                                                                                                                                                                                
# -*- coding: utf-8 -*-
# example gpiozero code that could be used to have a reboot
#  and a shutdown function on one GPIO button
# scruss - 2017-10

from gpiozero import Button
from gpiozero import LED
from signal import pause
from subprocess import check_call

# Button wired to BCM GPIO 26
use_button=26
# Button hold time thresholds in seconds
shutdown_threshold = 5.0
reboot_threshold = 2.0
held_for=0.0

# Nexus DR-X Shutdown LED is on BCM GPIO 24
led=LED(24)

# Adjust the following 2 variables as needed
# heartbeat LED on interval in seconds
on_time = 0.001
# time between hearbeats in seconds
heartbeat_interval = 2

def rls():
   # callback for when button is released
   global held_for
   if held_for > shutdown_threshold:
      check_call(['/sbin/poweroff'])
   elif held_for > reboot_threshold:
      check_call(['/sbin/reboot'])
   else:
      held_for = 0.0

def hld():
   # callback for when button is held
   # Function is called every hold_time seconds
   global held_for
   # need to use max() as held_time resets to zero on last callback
   held_for = max(held_for, button.held_time + button.hold_time)
   if held_for > shutdown_threshold:
      led.off()
   elif held_for > reboot_threshold:
      led.on()
   else:
      pass

button=Button(use_button, hold_time=1.0, hold_repeat=True)
# Register callback function for when button is pressed
button.when_held = hld
# Register callback function for when button is rleased
button.when_released = rls
# Blink the LED (runs in it's own thread in the background)
led.blink(on_time, heartbeat_interval)

# wait forever
pause()
