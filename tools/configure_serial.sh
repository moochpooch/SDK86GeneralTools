#! /bin/bash

if [ -z "$1" ]; then
	echo "No serial file input."
	exit 1
fi
serial_path=$1
base_path="${serial_path%/*}"

if [ -z "$2" ]; then
	baud=4800
else
	baud=$2
fi

if [[ "$base_path" != "/dev" ]]; then
	echo "Invalid base path, expected /dev/..."
	exit 1
fi

PORT_PID=$(sudo fuser /dev/ttyUSB0 2>&1)
if [ -z "$PORT_PID" ]; then
	stty -F "$serial_path" \
    		"$baud" \
    		cs8 cstopb -parenb \
    		-icanon -isig -iexten \
    		-echo -echoe -echok -echonl \
    		-opost \
    		-icrnl -inlcr -igncr \
    		-ixon -ixoff -ixany \
    		-crtscts \
    		clocal -hupcl \
    		min 1 time 0
	echo "Successful configuration"
	exit 0
else
	echo "Port locked by PID: ${PORT_PID}"
	exit 1
fi
