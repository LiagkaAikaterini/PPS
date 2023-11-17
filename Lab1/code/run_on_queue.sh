#!/bin/bash

##Describe job
#PBS -N run_Game_Of_Life

##Output and error files
#PBS -o run_Game_Of_Life.out
#PBS -e run_Game_Of_Life.err

##Machines
#PBS -l nodes=1:ppn=8

##Time
#PBS -l walltime=02:00:00

##Start
##Run make in src folder

core_num=(1 2 4 6 8)

for x in "${core_num[@]}"
do
	module load openmp
	cd /home/parallel/parlab20/a1
	export OMP_NUM_THREADS=${x}
	./Game_Of_Life 64 1000
	./Game_Of_Life 1024 1000
	./Game_Of_Life 4096 1000
done
