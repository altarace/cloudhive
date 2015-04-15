#!/bin/bash
what=`basename $0`
for p in `ps h -o pid -C $what`; do
        if [ $p != $$ ]; then
                exit 0
        fi
done
DATADIR=/home/pi/.cloudhive
for i in `ls -t $DATADIR`
do
    if test -f "$DATADIR/$i" 
    then
       echo "processing $DATADIR/$i"
       `cat "$DATADIR/$i"`
       if [ $? -ge 1 ]; then
          continue
       else
          rm -rf "$DATADIR/$i"
       fi
    fi
done

