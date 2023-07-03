#!/usr/bin/env bash

cd "$(dirname -- "$0")"
bumpkin eval --pretty -v -i ./bumpkin.json -o ./bumpkin.json.lock
