#!/bin/bash
rem echo "calculating fitness for $1 ..."
cd $(dirname $0)
n use 8.6.0 --expose-wasm fitness.js $1