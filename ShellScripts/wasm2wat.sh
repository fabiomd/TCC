#!/bin/bash
rem echo "compiling $1 to wat..."
cd $(dirname $0)
wasm2wat $1 -o $2