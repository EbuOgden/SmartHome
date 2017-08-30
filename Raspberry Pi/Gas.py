#!/usr/bin/env python
import PCF8591 as ADC
import RPi.GPIO as GPIO
import time
import math
import sys

DO = 22
GPIO.setmode(GPIO.BCM)

def setup():
        ADC.setup(0x48)
        GPIO.setup      (DO,    GPIO.IN)

def Print(x):
        if x == 0:
                print ''
                print '   *********'
                print '   * Safe~ *'
                print '   *********'
                print ''
        if x == 1:
                print ''
                print '   ***************'
                print '   * Danger Gas! *'
                print '   ***************'
                print ''

def loop():
        status = 1
        count = 0

        while True:
                tmp = GPIO.input(DO);
                print tmp
                sys.stdout.flush()
                time.sleep(0.2)

def destroy():
        GPIO.cleanup()

if __name__ == '__main__':
        try:
                setup()
                loop()
        except KeyboardInterrupt:
                destroy()
