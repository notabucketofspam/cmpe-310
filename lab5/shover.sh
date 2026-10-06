#!/usr/bin/sh
cd ..
./push.sh
labname=lab5
ssh oci2 "cd /home/opc/cmpe-310/$labname&& chmod +x docgen.pl&& ./docgen.pl"
echo "DONE"
sleep 10
