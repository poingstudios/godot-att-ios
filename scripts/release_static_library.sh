#!/bin/bash

PLUGIN="att"

# Compile Plugin
./scripts/generate_static_library.sh $PLUGIN release $1
./scripts/generate_static_library.sh $PLUGIN release_debug $1
mv ./bin/${PLUGIN}.release_debug.a ./bin/${PLUGIN}.debug.a

# Move to release folder
rm -rf ./bin/release
mkdir ./bin/release
rm -rf ./bin/release/${PLUGIN}/att/bin
mkdir -p ./bin/release/${PLUGIN}/att/bin

# Move Plugin
mv ./bin/${PLUGIN}.{release,debug}.a ./bin/release/${PLUGIN}/att/bin
cp ./plugin/${PLUGIN}/config/${PLUGIN}.gdip ./bin/release/${PLUGIN}
