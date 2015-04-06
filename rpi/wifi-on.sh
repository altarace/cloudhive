#!/bin/bash

SCRIPT_NAME=`basename $0`
LOGGER="/usr/bin/logger"
PING="/bin/ping"
GATEWAY="192.168.0.1"

function is_gateway_reachable
{
  LOSS=`$PING -w 5 -c 5 $GATEWAY 2>&1`
  $LOGGER -s -p cron.error -t $SCRIPT_NAME -i "LOSS is $LOSS"
  NUMLOSS=`echo $LOSS|grep -oP '\d+(?=% packet loss)'`
  $LOGGER -s -p cron.error -t $SCRIPT_NAME -i "NUMLOSS is $NUMLOSS"
  if [[ "$LOSS" == *"unreachable"* ]]
  then
   $LOGGER -s -p cron.error -t $SCRIPT_NAME -i "matched unreachable"
   return 1
  fi
  if [ "$NUMLOSS" = "100" ]
  then
    $LOGGER -s -p cron.error -t $SCRIPT_NAME -i "matched numloss 100"
    return 1
  fi
  echo "returning 0"
  return 0
}

if ! is_gateway_reachable
then
  sleep 30
  if ! is_gateway_reachable
  then
    $LOGGER -s -p cron.error -t $SCRIPT_NAME -i "Could not reach $GATEWAY. Restarting wireless interface."
    sudo /sbin/ifdown --force wlan0
    $LOGGER -s -p cron.error -t $SCRIPT_NAME -i "ifdown of wlan0 returned: $?"
    sleep 10
    sudo /sbin/ifup --force wlan0
    $LOGGER -s -p cron.error -t $SCRIPT_NAME -i "ifup of wlan0 returned: $?"
  fi
else
  $LOGGER -s -p cron.info -t $SCRIPT_NAME -i "Wireless interface operational"
fi
