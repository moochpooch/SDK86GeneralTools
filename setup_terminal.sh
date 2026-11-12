#! /bin/bash

if [[ $EUID -ne 0 ]]; then
    echo "ERROR: This script must be run with sudo or as root." >&2
    exit 1
fi

sudo stty -F /dev/ttyUSB0 4800 cs8 cstopb -parenb raw -echo

exit
