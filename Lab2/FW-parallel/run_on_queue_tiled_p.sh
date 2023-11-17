#!/bin/bash

## Give the Job a descriptive name
#PBS -N run_fw_tiled_p

## Output and error files
#PBS -o run_fw_tiled_p.out
#PBS -e run_fw_tiled_p.err

## How many machines should we get?
#PBS -l nodes=1:ppn=8

##How long should the job run for?
#PBS -l walltime=00:10:00

## Start
## Run make in the src folder (modify properly)

module load openmp
cd /home/parallel/parlab20/a2/FW-parallel

for thr in 1 2 4 8 16 32 64
  do
   export OMP_NUM_THREADS=$thr
   export OMP_PROC_BIND=true
   ./fw_tiled_parallel 1024 16
   ./fw_tiled_parallel 2048 16
   ./fw_tiled_parallel 4096 16
   ./fw_tiled_parallel 1024 8
   ./fw_tiled_parallel 2048 8
   ./fw_tiled_parallel 4096 8
  done
