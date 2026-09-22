#!/usr/bin/sh
cd ..
./push.sh
ssh brick_wg0 "cd /home/brick/cmpe-310/lent&&gcc -no-pie -nostdlib lent.s -o lent&& ./lent"
echo "DONE"
sleep 10
