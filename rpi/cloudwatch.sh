#!/bin/bash
what=`basename $0`
for p in `ps h -o pid -C $what`; do
        if [ $p != $$ ]; then
                exit 0
        fi
done
DATADIR=/home/pi/.cloudhive
TEMPVAR="Temp"
HUMVAR="Hum"
LBVAR="Weight"
NAMESPACE="LOC-1"

if [ ! -d ${DATADIR} ]; then
   mkdir ${DATADIR}
fi

DATUM=`date +%s`
RES=`sudo python /home/pi/cloudhive/rpi/ht.py`
TEMP=`echo $RES|awk '{print $1}'`
HUM=`echo $RES|awk '{print $2}'`
#random weight simulator
RLBS=`sudo /home/pi/hx711/hx711 223045`
LBS=$(($RLBS*-1*6671/1000000+4848))
PID=`grep -Po '^Serial\s*:\s*\K[[:xdigit:]]{16}' /proc/cpuinfo`
DATAS=\"${DATUM},${TEMP},${HUM},${PID},$LBS\"
echo ${DATAS}

if [ $LBS -ge 1 ]; then
echo $LBS>weight.txt
else
LBS=`cat weight.txt`
fi


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

/usr/local/bin/aws cloudwatch put-metric-data --metric-name ${LBVAR} \
--namespace ${NAMESPACE} --value $LBS --timestamp $DATUM --dimensions \
Item=${PID}

if [ $? -ge 1 ]; then
printf "/usr/local/bin/aws cloudwatch put-metric-data --metric-name ${LBVAR} \
--namespace ${NAMESPACE} --value $LBS --timestamp $DATUM --dimensions \
Item=${PID}">${DATADIR}/${DATUM}w
fi

