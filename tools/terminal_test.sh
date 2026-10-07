#!/usr/bin/env bash
set -euo pipefail

SERIAL_PORT=/dev/ttyUSB0

./configure_serial.sh "$SERIAL_PORT"

# One persistent read/write connection to the serial device.
exec 3<>"$SERIAL_PORT"
trap 'exec 3>&- 3<&-' EXIT

printf 'DW0000:0100,0256' >&3

while IFS= read -r -t 0.05 -u 3 line; do
    line=${line%$'\r'}
    printf '\nSDK: %s\n' "$line"
done

