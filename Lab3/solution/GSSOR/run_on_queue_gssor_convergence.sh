#!/bin/bash

## Give the Job a descriptive name
#PBS -N run_gssor

## Output and error files
#PBS -o run_gssor_convergence.out
#PBS -e run_gssor_convergence.err

## Limit memory, runtime etc.
#PBS -l walltime=01:00:00

## How many nodes:processors_per_node should we get?
#PBS -l nodes=8:ppn=8


module load openmpi/1.8.3
cd /home/parallel/parlab20/a3/solution/GSSOR

for i in 1 2 3
do
	echo "Iteration ${i}"
	mpirun -np 64 --map-by node --mca btl self,tcp ./gssor 1024 1024 8 8
done
