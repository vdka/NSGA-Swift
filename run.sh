#!/bin/bash

./.build/release/NSGA $(pwd) $(od -vAn -N4 -tx4 < /dev/urandom | tr -d [:space:] ) 299 100
