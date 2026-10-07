#!/usr/bin/sh
cd ..
./push.sh
labname=lab5
ssh oci2 "cd /home/opc/cmpe-310/$labname&& chmod +x run-max.sh&& ./run-max.sh"
echo "DONE"
sleep 10
