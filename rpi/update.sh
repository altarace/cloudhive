#!/bin/bash
PID=`grep -Po '^Serial\s*:\s*\K[[:xdigit:]]{16}' /proc/cpuinfo`
echo IN UPDATE ${PID}
what=`basename $0`
for p in `ps h -o pid -C $what`; do
        if [ $p != $$ ]; then
                exit 0
        fi
done
DATUM=`date +%s`
rm -rf /home/pi/patch.sh
/usr/loca/bin/aws s3 cp s3://HIVE_BUCKET/${PID}/patch.sh /home/pi/patch.sh
chmod +x /home/pi/patch.sh
sh /home/pi/patch.sh>/home/pi/output-$DATUM.txt
/usr/loca/bin/aws s3 cp /home/pi/output-$DATUM.txt s3://HIVE_BUCKET/${PID}/output-$DATUM.txt
rm /home/pi/output-$DATUM.txt

