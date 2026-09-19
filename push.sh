#!/bin/sh
rsync --recursive --delete --exclude=".vs/***" --exclude=".git/***" --exclude="x64/***" -e "ssh -i \"/c/notkeys/lolpc-ii/brick.priv\"" ./ brick_wg0:/home/brick/cmpe-310/
echo "rsync done"
