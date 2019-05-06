#!/bin/bash

inotifywait -q -e close_write,moved_to -m . |
while read -r directory events filename; do
	if [ "$filename" = "$1" ]; then
		clear
		git commit -a -m "auto push" && git push
	fi
done
