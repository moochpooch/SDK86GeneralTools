#! /bin/bash
if [ "$#" -ne 1 ]; then
	echo "Error: Invalid number of arguments" >&2
	echo "Usage: $0 <filename>" >&2
	exit 1
fi

filename=$1
filename_noext="${filename%.asm}"

if [ ! -f "$filename" ]; then
	echo "Error: file(${1}) not found" >&2
	exit 1
fi

nasm -f bin -l "${filename_noext}.lst" -o outfile.bin $filename

# if nasm -f bin -l "${filename_noext}.lst" -o outfile.bin $filename; then
# 	mv ./"${filename_noext}.lst" /home/jonathan/Projects/SDK-86_Loader/Programs/
# fi

