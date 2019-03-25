#!/bin/bash
rem echo "compiling ${1}.wat to ${1}.wasm ..."
cd $(dirname $0)
wat2wasm temp/watcode/${1}.wat -o temp/wasmcode/${1}.wasm