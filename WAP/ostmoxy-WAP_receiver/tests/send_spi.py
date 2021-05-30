#!/usr/bin/env python
import wiringpi
wiringpi.wiringPiSetup()
serial = wiringpi.serialOpen('/dev/serial0',57600)
wiringpi.serialPuts(serial,'hello world!\n')
