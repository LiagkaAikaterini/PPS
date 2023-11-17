#!/bin/bash

## Give the job a descriptive name
#PBS -N make

## Output files
#PBS -o make.out
#PBS -e make.err

## How many machines?
#PBS -l nodes=1:ppn=1

## How long should the job run for?
#PBS -l walltime=00:01:00

## Start
## Run make in src folder

cd /home/parallel/parlab20/a4/dmm-skeleton
make DEBUG=0
