#!/bin/bash
rem echo "applying test cases for $1 ..."
cd $(dirname $0)
n use 8.6.0 --expose-wasm $2 $1