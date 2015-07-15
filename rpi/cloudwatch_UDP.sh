#!/bin/bash
what=`basename $0`
for p in `ps h -o pid -C $what`; do
        if [ $p != $$ ]; then
                exit 0
        fi
done


if [ ! -d ${DATADIR} ]; then
   mkdir ${DATADIR}
fi

DATUM=`date +%s`
RES=`sudo python /home/pi/cloudhive/rpi/ht.py`
TEMP=`echo $RES|awk '{print $1}'`
HUM=`echo $RES|awk '{print $2}'`
LBS=`sudo /home/pi/hx711/hx711 0`
PID=`grep -Po '^Serial\s*:\s*\K[[:xdigit:]]{16}' /proc/cpuinfo`


if [ $LBS -le 10 ] ; then
LBS=`cat /home/pi/weight.txt`
else
echo $LBS>/home/pi/weight.txt
fi

echo -n "${PID}_${TEMP}_${HUM}_${LBS}_${DATUM}"|nc -4u -w1 EIP 20000

