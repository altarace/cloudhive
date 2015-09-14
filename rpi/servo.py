#NOT USED
import RPi.GPIO as GPIO

import time

GPIO.setmode(GPIO.BOARD)

GPIO.setup(11,GPIO.OUT)

freq = 50
pwm= GPIO.PWM(11,freq)

leftp=0.75
rightp = 2.5
midp = (rightp - leftp)/2 +leftp
mspercycle = 1000/freq
dutycyup = midp*100/mspercycle
dutydown = 2.3*100/mspercycle
pwm.start(dutycyup)
time.sleep(.5)
pwm.start(dutydown)
time.sleep(.5)
pwm.start(dutycyup)
time.sleep(.5)
pwm.stop()
GPIO.cleanup()
