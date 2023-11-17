#!/bin/bash

#PBS -o scenario1.out
#PBS -e scenario1.err
#PBS -l walltime=06:00:00
#PBS -l nodes=dungani:ppn=24:cuda

export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH
export CUDA_VISIBLE_DEVICES=2

gpu_kernels="0 1 2"
problem_sizes="256 512 1024 2048"
block_sizes="4 8 16 32"
gpu_prog="./dmm_main"

cd /home/parallel/parlab20/a4/dmm-skeleton/cuda
echo "Benchmark started on $(date) in $(hostname)"
for i in $gpu_kernels; do
  for b in $block_sizes; do
      make -s clean
      make -s THREAD_BLOCK_X=$b THREAD_BLOCK_Y=$b TILE_X=$b TILE_Y=$b DEBUG=0 CHECK=0
      GPU_KERNEL=$i $gpu_prog 2048 2048 2048
  done
done
echo "Benchmark ended on $(date) in $(hostname)"
