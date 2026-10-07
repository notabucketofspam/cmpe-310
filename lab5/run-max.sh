#!/usr/bin/sh
fname=max
gcc -no-pie -nostdlib "$fname".s -o "$fname"
valgrind -s ./"$fname"
# ./"$fname"
