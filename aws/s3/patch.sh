#!/bin/bash
PID=`grep -Po '^Serial\s*:\s*\K[[:xdigit:]]{16}' /proc/cpuinfo`
DATUM=`date +"%s"`
TDATE=`date +"%m-%d-%y"`
echo ${PID}
#/usr/bin/raspivid -o /home/pi/video.h264 -t 10000
#/usr/local/bin/aws s3 cp /home/pi/video.h264  s3://HIVE_BUCKET/${PID}/${TDATE}/${DATUM}-video.h264