#!/usr/bin/sh
cd ..
./push.sh
ssh brick_wg0 "cd /home/brick/cmsc-310/lab3&&source ./runme"
