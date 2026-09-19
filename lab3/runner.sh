#!/usr/bin/sh
cd ..
./push.sh
ssh brick_wg0 "cd /home/brick/cmpe-310/lab3&&gcc -no-pie -nostdlib lab3.s -o lab3"
echo "build ok"
sleep 10
