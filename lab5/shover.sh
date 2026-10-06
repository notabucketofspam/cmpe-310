#!/usr/bin/sh
cd ..
./push.sh
labname=lab5
ssh oci2 "cd /home/opc/cmpe-310/$labname&& chmod +x runme&& ./runme"
echo "DONE"
sleep 10
