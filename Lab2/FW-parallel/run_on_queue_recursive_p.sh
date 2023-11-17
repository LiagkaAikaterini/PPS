#!/bin/bash

## Give the Job a descriptive name
#PBS -N run_fw_recursive_p

## Output and error files
#PBS -o run_fw_recursive_p.out
#PBS -e run_fw_recursive_p.err

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
  ./fw_recursive_parallel 1024 32
  ./fw_recursive_parallel 2048 32
  ./fw_recursive_parallel 4096 32
  ./fw_recursive_parallel 1024 64
  ./fw_recursive_parallel 2048 64
  ./fw_recursive_parallel 4096 64
  ./fw_recursive_parallel 1024 128
  ./fw_recursive_parallel 2048 128
  ./fw_recursive_parallel 4096 128
done

