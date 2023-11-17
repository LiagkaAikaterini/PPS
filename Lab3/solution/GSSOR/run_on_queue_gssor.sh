#!/bin/bash

## Give the Job a descriptive name
#PBS -N run_gssor

## Output and error files
#PBS -o run_gssor.out
#PBS -e run_gssor.err

## Limit memory, runtime etc.
#PBS -l walltime=01:30:00

## How many nodes:processors_per_node should we get?
#PBS -l nodes=8:ppn=8


module load openmpi/1.8.3
cd /home/parallel/parlab20/a3/solution/GSSOR

for j in 6144
do
	for i in 1 2 3
		do
			echo "Array Length ${j}"
			echo "Iteration ${i}"
			mpirun -np 1 --map-by node --mca btl self,tcp ./gssor ${j} ${j} 1 1
			mpirun -np 2 --map-by node --mca btl self,tcp ./gssor ${j} ${j} 2 1
			mpirun -np 4 --map-by node --mca btl self,tcp ./gssor ${j} ${j} 2 2
			mpirun -np 8 --map-by node --mca btl self,tcp ./gssor ${j} ${j} 4 2
			mpirun -np 16 --map-by node --mca btl self,tcp ./gssor ${j} ${j} 4 4
			mpirun -np 32 --map-by node --mca btl self,tcp ./gssor ${j} ${j} 8 4
			mpirun -np 64 --map-by node --mca btl self,tcp ./gssor ${j} ${j} 8 8
		done
done
