#!/usr/bin/sh
fname=lab9
gcc -no-pie -nostdlib "$fname".S -o "$fname"
# valgrind -s ./"$fname"
./"$fname"
