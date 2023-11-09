#!/usr/bin/env bash

cd "$(dirname -- "$0")"

curl https://hex-rays.com/ida-free/ | grep -E '^[a-f0-9]{64} .*linux.run' > latest.txt
