#!/bin/bash

./build.sh

mkdir -p results

GENERATIONS=${1:-999}
POPULATION=${2:-100}

commit=`git rev-parse --short HEAD`
branch=`git rev-parse --abbrev-ref HEAD`

SEED=${3:-$(od -vAn -N4 -tx4 < /dev/urandom | tr -d [:space:] )}

echo "Using seed: $SEED"

mkdir -p results/$SEED

zip -r results/$SEED/code.zip . -x '*Packages*' -x '*.build*' -x '*.git*' -x '*results*' -x '*.DS_Store*' > /dev/null

./.build/release/NSGA $(pwd) $SEED $GENERATIONS $POPULATION

echo >> $(pwd)/results/$SEED/CONFIG.txt
echo $(date +"%d-%m @ %H:%m") >> $(pwd)/results/$SEED/CONFIG.txt
echo "$branch - $commit" >> $(pwd)/results/$SEED/CONFIG.txt

