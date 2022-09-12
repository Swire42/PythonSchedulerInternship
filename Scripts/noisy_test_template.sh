#!/bin/bash

# This is a template for a noisy test.
# It must be ran with superuser privileges (to intereact with ghOSt).
# This test has noise because CFS has priority over ghOSt.
# To solve this, assign some cpus to CFS and other cpus to the ghOSt enclave.

# Placeholders:
# NAME: name of the test
# ./SCHED.sh: script to start the scheduler (ex: start_fifo_cpp.sh)
# ./APP: command to launch the app you want to use for testing
# NB_TESTS: how many repetitions of the test
# NB_APPS: how many apps launched per test

echo "NAME"

./SCHED.sh &> sched.log

for k in {1..NB_TESTS}
do
/usr/bin/time -f "%e" bash -c 'for i in {1..NB_APPS}; do ./APP > /dev/null & echo $! >> /sys/fs/ghost/enclave_1/tasks; done; wait'
done

./stop_ghost.sh
