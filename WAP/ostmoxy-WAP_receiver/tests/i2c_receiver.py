#!/usr/bin/env python
import time
import pigpio
import RPi.GPIO as GPIO
import subprocess
import os

SDA=2
SCL=3

I2C_ADDR=8

print "Start"
def i2c(id, tick):
   global pi
   s, b, d = pi.bsc_i2c(I2C_ADDR)
   #GPIO.output(17, GPIO.HIGH)
   if b:
      #print(d[:-1])
      if d=="wifion":
        print "An"
        # os.system ('rfkill unblock wifi')

      if d=="wifioff":
        print "Aus"
        # os.system ('rfkill block wifi')

      print d

pi = pigpio.pi()
if not pi.connected:
    exit()
# Add pull-ups in case external pull-ups haven't been added
pi.set_pull_up_down(SDA, pigpio.PUD_UP)
pi.set_pull_up_down(SCL, pigpio.PUD_UP)
# Respond to BSC slave activity
e = pi.event_callback(pigpio.EVENT_BSC, i2c)
pi.bsc_i2c(I2C_ADDR) # Configure BSC as I2C slave
time.sleep(600)
e.cancel()
pi.bsc_i2c(0) # Disable BSC peripheral
pi.stop()