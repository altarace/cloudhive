#!/bin/bash
/usr/local/bin/aws kinesis put-record --stream-name altarace --data "`TZ=America/New_York date``sudo python temp.py`"  --partition-key shardId-000000000000
