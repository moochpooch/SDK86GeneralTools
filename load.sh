#! /bin/bash

ASSM_PROGRAM="./tools/assembler.sh"
FILE="$1"
BYTE_SEGMENT="$2"
OUTFILE="./outfile.bin"
MON_PROGRAM="./tools/monitor_encoder.out"
ADDRESS_TOOL="./tools/NASMLstIdentifier.out"

if [ "$#" -lt 1 ]; then
	echo "Usage: $0 <file_name> <optional segment>"
	exit 1
fi

if [ -z "$2" ]; then
	echo "Argument 2 left empty, defaulting to segment 0000"
	BYTE_SEGMENT="0000"
fi

trap 'rm -f "$OUTFILE"' EXIT

if ! "$ASSM_PROGRAM" "$FILE"; then
	exit 1
fi

BASE_NAME=$(basename "$FILE")
FILE_NAME="${BASE_NAME%%.*}"

ADDRESSES=$($ADDRESS_TOOL "./Programs/${FILE_NAME}.lst")
if [ -z "$ADDRESSES" ]; then
	echo "No declared data found"
else
	echo "$ADDRESSES"
fi

# Need to make a more robust system for searching for ORG
ORG=""
read -r ORG < "$FILE"
OFFSET="${ORG#* }"
OFFSET="${OFFSET%h}"

if ! HEX_STRING=$("$MON_PROGRAM" "$OUTFILE"); then
	echo "Monitor program failure"
	exit 1
fi

SEG_OFFSET="${BYTE_SEGMENT}:${OFFSET}"

FORMATTED_STRING="SW${SEG_OFFSET},${HEX_STRING}"
printf '%s\r' "$FORMATTED_STRING" > "./Programs/$(basename "$FILE" .asm).out"
echo "File created to load at ${SEG_OFFSET}"

exit 0
