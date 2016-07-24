#!/bin/bash

mkdir -p results

GENERATIONS=299
POPULATION=100

./.build/release/NSGA $(pwd) $(od -vAn -N4 -tx4 < /dev/urandom | tr -d [:space:] ) $GENERATIONS $POPULATION
