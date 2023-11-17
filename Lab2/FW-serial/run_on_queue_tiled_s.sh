#!/bin/bash

## Give the Job a descriptive name
#PBS -N run_fw_tiled_s

## Output and error files
#PBS -o run_fw_tiled_s.out
#PBS -e run_fw_tiled_s.err

## How many machines should we get?

##How long should the job run for?
#PBS -l walltime=00:30:00

## Start
## Run make in the src folder (modify properly)

module load openmp
cd /home/parallel/parlab20/a2/FW-serial
for thr in 1 2 4 8 16 32 64
do
 export OMP_NUM_THREADS=$thr
 ./fw_tiled 1024 64
 ./fw_tiled 2048 64
 ./fw_tiled 4096 64
done
