#!/bin/bash
DATADIR=/home/pi/.cloudhive
TEMPVAR="Temp"
HUMVAR="Hum"
NAMESPACE="LOC-1"

if [ ! -d ${DATADIR} ]; then
   mkdir ${DATADIR}
fi

DATUM=`date +%s`
RES=`sudo python /home/pi/cloudhive/rpi/ht.py`
TEMP=`echo $RES|awk '{print $1}'`
HUM=`echo $RES|awk '{print $2}'`
PID=`grep -Po '^Serial\s*:\s*\K[[:xdigit:]]{16}' /proc/cpuinfo`
DATAS=\"${DATUM},${TEMP},${HUM},${PID}\"
echo ${DATAS}

/usr/local/bin/aws cloudwatch put-metric-data --metric-name ${TEMPVAR} \
--namespace ${NAMESPACE} --value $TEMP --timestamp $DATUM --dimensions \
Item=${PID}

if [ $? -ge 1 ]; then
printf "/usr/local/bin/aws cloudwatch put-metric-data --metric-name ${TEMPVAR} \
--namespace ${NAMESPACE} --value $TEMP --timestamp $DATUM --dimensions \
Item=${PID}">${DATADIR}/${DATUM}t
fi

/usr/local/bin/aws cloudwatch put-metric-data --metric-name ${HUMVAR} \
--namespace ${NAMESPACE} --value $HUM --timestamp $DATUM --dimensions \
Item=${PID}

if [ $? -ge 1 ]; then
printf "/usr/local/bin/aws cloudwatch put-metric-data --metric-name ${HUMVAR} \
--namespace ${NAMESPACE} --value $HUM --timestamp $DATUM --dimensions \
Item=${PID}">${DATADIR}/${DATUM}h
fi

