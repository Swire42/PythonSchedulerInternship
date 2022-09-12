#!/bin/bash

if [ $(id -u) -ne 0 ]
  then echo "Please run with sudo"
  exit
fi

cd /home/x/ghost-userspace
# This is done in 2 steps because building might take long and we want to be sure that the scheduler is running when the script finishes.
bazel build python_fifo -c opt
bazel run python_fifo -c opt &
sleep 1
