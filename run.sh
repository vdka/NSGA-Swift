#!/bin/bash

mkdir -p results

GENERATIONS=${1:-999}
POPULATION=${2:-100}

SEED=$(od -vAn -N4 -tx4 < /dev/urandom | tr -d [:space:] )

echo "Using seed: $SEED"

./.build/debug/NSGA $(pwd) $SEED $GENERATIONS $POPULATION

