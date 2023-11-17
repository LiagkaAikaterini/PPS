#!/bin/bash

## Give the Job a descriptive name
#PBS -N make_jacobi

## Output and error files
#PBS -o make_jacobi.out
#PBS -e make_jacobi.err

## Limit memory, runtime etc.
#PBS -l walltime=00:10:00

## How many nodes:processors_per_node should we get?
#PBS -l nodes=1:ppn=1


module load openmpi/1.8.3
cd /home/parallel/parlab20/a3/solution/Jacobi
make
