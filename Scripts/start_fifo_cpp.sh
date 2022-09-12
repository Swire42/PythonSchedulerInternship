#!/bin/bash

if [ $(id -u) -ne 0 ]
  then echo "Please run with sudo"
  exit
fi

cd /home/x/ghost-userspace
# This is done in 2 steps because building might take long and we want to be sure that the scheduler is running when the script finishes.
bazel build fifo_per_cpu_agent -c opt
bazel run fifo_per_cpu_agent -c opt -- --ghost_cpus "0-7" &
sleep 1
