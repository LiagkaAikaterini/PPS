#!/bin/bash

## Give the Job a descriptive name
#PBS -N make_gssor

## Output and error files
#PBS -o make_gssor.out
#PBS -e make_gssor.err

## Limit memory, runtime etc.
#PBS -l walltime=00:10:00

## How many nodes:processors_per_node should we get?
#PBS -l nodes=1:ppn=1


module load openmpi/1.8.3
cd /home/parallel/parlab20/a3/solution/GSSOR
make