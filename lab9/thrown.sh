#!/usr/bin/sh
cd ..
./push.sh
labname=lab9
ssh oci2 "cd /home/opc/cmpe-310/$labname&& chmod +x run-lab.sh&& ./run-lab.sh"
echo "DONE"
#sleep 10
