#!/bin/bash

##Descriptive name of job
#PBS -N make_Game_Of_Life

##Output and error files
#PBS -o make_Game_Of_Life.out
#PBS -e make_Game_Of_Life.err

##Machines
#PBS -l nodes=1:ppn=1

##Time
#PBS -l walltime=00:30:00

##Start
##Run make in src folder

module load openmp
cd /home/parallel/parlab20/a1
make
