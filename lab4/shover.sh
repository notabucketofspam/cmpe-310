#!/usr/bin/sh
cd ..
./push.sh
labname=lab4
ssh brick_wg0 "cd /home/brick/cmpe-310/$labname&& chmod +x runme&& ./runme"
echo "DONE"
sleep 10
