#!/bin/bash

## Give the Job a descriptive name
#PBS -N test

## Output and error files
#PBS -o test.out
#PBS -e test.err

##How long should the job run for?
#PBS -l walltime=00:10:00

## Start 
## Run make in the src folder

cd /home/parallel/parlab20/a5/z2

locks=( "test_pthread" "test_ttas" "test_array" )

for i in "${locks[@]}";
do 
	echo "${i}"
	for thr in 1 2 4 8 16 32 64
	do
		./${i} ${thr}
 	done
done
