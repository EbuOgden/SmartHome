#!/usr/bin/env python
import RPi.GPIO as GPIO
import time
import sys

Buzzer = 6    # pin11

GPIO.setwarnings(False)

def setup(pin):
        global BuzzerPin
        BuzzerPin = pin
        GPIO.setmode(GPIO.BCM)       # Numbers GPIOs by physical location
        GPIO.setup(BuzzerPin, GPIO.OUT)
        GPIO.output(BuzzerPin, GPIO.HIGH)

def on():
        GPIO.output(BuzzerPin, GPIO.LOW)

def off():
        GPIO.output(BuzzerPin, GPIO.HIGH)

def beep(x):
        on()
        time.sleep(x)
        off()
        time.sleep(x)

def loop():
        while True:
                beep(0.5)

def destroy():
        GPIO.output(BuzzerPin, GPIO.HIGH)
        GPIO.cleanup()                     # Release resource

if __name__ == '__main__':     # Program start from here
        setup(Buzzer)
        try:
                on();
        except KeyboardInterrupt:  # When 'Ctrl+C' is pressed, the child program destroy() will be  executed.
                destroy()
