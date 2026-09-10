#!/bin/sh
rsync --recursive --delete --exclude=".vs/***" --exclude=".git/***" -e "ssh -i \"/c/notkeys/lolpc-ii/brick.priv\"" ./ brick@10.0.0.2:/home/brick/cmsc-310/
echo done
