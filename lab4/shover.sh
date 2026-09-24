#!/usr/bin/sh
cd ..
./push.sh
labname=lab4
ssh brick_wg0 "cd /home/brick/cmpe-310/$labname&&gcc -no-pie -nostdlib $labname.s -o $labname"
echo "build ok"
sleep 5
