#!/usr/bin/env python
import serial
serial = serial.Serial( '/dev/serial0', baudrate = 57600 )
while 1:
	rx_data = serial.readline()
	print rx_data
