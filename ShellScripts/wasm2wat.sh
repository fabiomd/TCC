#!/bin/bash
# rem echo "compiling $1 to wat..."
# cd $(dirname $0)
# cd /d "%~dp0"
# echo "compiling $1 to wat..."
wasm2wat $1 -o $2