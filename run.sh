#!/bin/bash

mkdir -p results

GENERATIONS=${1:-999}
POPULATION=${2:-100}

commit=`git rev-parse --short HEAD`
branch=`git rev-parse --abbrev-ref HEAD`

SEED=$(od -vAn -N4 -tx4 < /dev/urandom | tr -d [:space:] )

echo "Using seed: $SEED"

./.build/release/NSGA $(pwd) $SEED $GENERATIONS $POPULATION

echo >> $(pwd)/results/$SEED/CONFIG.txt
echo $(date +"%d-%m @ %H:%m") >> $(pwd)/results/$SEED/CONFIG.txt
echo "$branch - $commit" >> $(pwd)/results/$SEED/CONFIG.txt

zip -r results/code.zip . -x '*Packages*' -x '*.build*' -x '*.git*' -x '*results*' -x '*.DS_Store*' > /dev/null

