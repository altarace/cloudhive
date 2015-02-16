#!/bin/bash
DATADIR=/home/pi/.cloudhive
for i in `ls $DATADIR`
do
    if test -f "$DATADIR/$i" 
    then
       `cat "$DATADIR/$i"`
       if [ $? -ge 1 ]; then
          exit $?
       else
          rm -rf "$DATADIR/$i"
       fi
    fi
done

