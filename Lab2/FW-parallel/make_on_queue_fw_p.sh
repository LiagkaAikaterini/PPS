#!/bin/bash

## Give the Job a descriptive name
#PBS -N make_fw_p

## Output and error files
#PBS -o make_fw_p.out
#PBS -e make_fw_p.err

## How many machines should we get?

##How long should the job run for?
#PBS -l walltime=00:10:00

## Start
## Run make in the src folder (modify properly)

module load openmp
cd /home/parallel/parlab20/a2/FW-parallel
make clean
gcc -Wall -fopenmp -c util.c
gcc util.o fw_parallel_v1.c -o fw_p -Wall -O3 -fopenmp -Wno-unused-variable 
