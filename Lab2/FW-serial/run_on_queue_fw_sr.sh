#!/bin/bash

## Give the Job a descriptive name
#PBS -N run_fw_sr

## Output and error files
#PBS -o run_fw_sr.out
#PBS -e run_fw_sr.err

## How many machines should we get?

##How long should the job run for?
#PBS -l walltime=00:30:00

## Start
## Run make in the src folder (modify properly)

module load openmp
cd /home/parallel/parlab20/a2/FW-serial
export OMP_NUM_THREADS=1
./fw_sr 1024
./fw_sr 2048
./fw_sr 4096

