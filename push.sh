#!/bin/sh
rsync --recursive --delete --exclude=".vs/***" --exclude=".git/***" --exclude="x64/***" -e "ssh -i \"/c/Cloud/IaaS/Oracle/OCI2/oci2\"" ./ oci2:/home/opc/cmpe-310/
echo "rsync done"
