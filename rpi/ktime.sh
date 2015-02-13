#!/bin/bash
/usr/local/bin/aws kinesis put-record --stream-name altarace --data "`TZ=America/New_York date``sudo python cloudhive/rpi/temp.py``grep -Po '^Serial\s*:\s*\K[[:xdigit:]]{16}' /proc/cpuinfo`"  --partition-key shardId-000000000000
