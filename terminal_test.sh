#!/bin/bash
# Script assumes ttyUSB0 as serial port
#

if [ $# != 1 ]; then
	echo "Usage: ./terminal_test <filename>"
	exit 1
fi

file_path=$1
file_type=$(file -b "./$1")

if [[ $file_type != *"ASCII text"* ]]; then
	echo "ERROR: file ${1} is not ASCII text" >&2
	exit 1
fi

# open terminal, async
#sudo cat /dev/ttyUSB0 &
#cat_PID=$!

# send file to serial
cat "$file_path" | pv -q -L 10 | sudo tee /dev/ttyUSB0 > /dev/null

# kill viewing terminal
#kill "$cat_PID"
