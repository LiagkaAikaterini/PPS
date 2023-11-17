#!/bin/bash

## Give the Job a descriptive name
#PBS -N run_fw_p

## Output and error files
#PBS -o run_fw_p.out
#PBS -e run_fw_p.err

## How many machines should we get?

##How long should the job run for?
#PBS -l walltime=00:30:00

## Start
## Run make in the src folder (modify properly)

module load openmp
cd /home/parallel/parlab20/a2/FW-parallel
for thr in 1 2 4 8 16 32 64
 do
  export OMP_NUM_THREADS=$thr
  ./fw_p 1024
  ./fw_p 2048
  ./fw_p 4096
 done
