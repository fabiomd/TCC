#!/bin/bash
#rem echo "compiling $1 to wasm..."
#cd $(dirname $0)
# echo "compiling $1 to wasm..."
#cd /d $0
#echo $0 $1 $2
wat2wasm $1 -o $2