#!/bin/bash

if [ $(id -u) -ne 0 ]
  then echo "Please run with sudo"
  exit
fi

# This line produces an error (not found) if no ghOSt scheduler is currently running. This is fine.
for k in /sys/fs/ghost/enclave_*/ctl; do echo destroy > $k; done
