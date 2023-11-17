#!/bin/bash

## Give the Job a descriptive name
#PBS -N make_sync

## Output and error files
#PBS -o make_sync.out
#PBS -e make_sync.err

## How many machines should we get?

##How long should the job run for?
#PBS -l walltime=00:10:00

## Start
## Run make in the src folder (modify properly)

cd /home/parallel/parlab20/a5/z3
make
