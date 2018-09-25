#!/bin/bash
rem echo "compiling ${1}.wasm to ${1}.wat ..."
cd $(dirname $0)
wasm2wat temp/wasmcode/${1}.wasm -o temp/wastcode/${1}.wat