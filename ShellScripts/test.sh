#!/bin/bash
#rem echo "applying test cases for $1 ..."
# cd $(dirname $0)
#cd /d "%~dp0"
# echo "applying test cases for $1 ..."
node --expose-wasm .$1 .$2