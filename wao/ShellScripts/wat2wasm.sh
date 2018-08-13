#!/bin/bash
rem echo "compiling $1 to wasm..."
cd $(dirname $0)
wat2wasm $1 -o $2