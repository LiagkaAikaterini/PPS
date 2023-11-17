#!/bin/bash

## Give the Job a descriptive name
#PBS -N run_sync_fgl

## Output and error files
#PBS -o run_sync_fgl.out
#PBS -e run_sync_fgl.err

##How long should the job run for?
#PBS -l walltime=01:00:00

## Start
## Run make in the src folder

cd /home/parallel/parlab20/a5/z3

operation_stats=( "80 10 10" "20 40 40" )

for size in 1024 8192
do
	echo "${size}"
	for op in "${operation_stats[@]}"
	do
		MT_CONF=0 ./fine_grain ${size} ${op}

		MT_CONF=0,1 ./fine_grain ${size} ${op}

		MT_CONF=0,1,2,3 ./fine_grain ${size} ${op}

		MT_CONF=0,1,2,3,4,5,6,7 ./fine_grain ${size} ${op}

		MT_CONF=0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15 ./fine_grain ${size} ${op}
	
		MT_CONF=0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31 ./fine_grain ${size} ${op}

		MT_CONF=0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63 ./fine_grain ${size} ${op}

	done
done

