/*
 *  dmm_gpu.cu -- Template for DMM GPU kernels
 *
 *  Copyright (C) 2020, Computing Systems Laboratory (CSLab)
 *  Copyright (C) 2020, Athena Elafrou/Petros Anastasiadis
 */

#include "dmm.h"
#include "stdio.h"
#include <cublas_v2.h>

/*
 *  Naive kernel
 */
__global__ void dmm_gpu_naive(const value_t *A, const value_t *B, value_t *C,
                              const size_t M, const size_t N, const size_t K) {

    int tidx,tidy;
    value_t sum = 0;
    tidx = blockDim.x * blockIdx.x + threadIdx.x;
    tidy = blockDim.y * blockIdx.y + threadIdx.y;

    if (tidx<N && tidy<M)
    {
        for (int i=0; i<K; i++)
        {
            sum = sum + A[tidy*K+i]*B[tidx+N*i];
        }

        C[tidy*N+tidx] = sum;
    } 
}

/*
 *  Coalesced memory acceses of A.
 */
__global__ void dmm_gpu_coalesced_A(const value_t *A, const value_t *B,
				    value_t *C, const size_t M, const size_t N,
				    const size_t K) {
  /*
   * FILLME: fill the code.
   */
    __shared__ value_t A_shared[TILE_Y][TILE_X];
    
    int bx = blockIdx.x;
    int by = blockIdx.y;
    int tx = threadIdx.x;
    int ty = threadIdx.y;

    int col = bx * TILE_X + tx;
    int row = by * TILE_Y + ty;

    value_t sum = 0;

    for (int i=0; i<(K+TILE_X-1)/TILE_X; i++) {
        A_shared[ty][tx] = A[row*K + (i*TILE_X+tx)];

        __syncthreads();

        for(int k=0; k<TILE_X; k++) {
            sum += A_shared[ty][k]*B[(i*TILE_X+k)*N+col];
        }
    }

    C[row*N+col] = sum;
}

/*
 *  Reduced memory accesses.
 */
__global__ void dmm_gpu_reduced_global(const value_t *A, const value_t *B, value_t *C,
				       const size_t M, const size_t N, const size_t K) {
  /*
   * FILLME: fill the code.
   */
    __shared__ value_t A_shared[TILE_Y][TILE_X];
    __shared__ value_t B_shared[TILE_Y][TILE_X];

    int bx = blockIdx.x;
    int by = blockIdx.y;
    int tx = threadIdx.x;
    int ty = threadIdx.y;
    
    int col = bx * TILE_X + tx;
    int row = by * TILE_Y + ty;

    value_t sum = 0;

    for (int i=0; i<(K+TILE_X-1)/TILE_X; i++) {
        A_shared[ty][tx] = A[row*K + i*TILE_X+tx];
        B_shared[ty][tx] = B[col + (i*TILE_Y+ty)*N];

        __syncthreads();

        for(int k=0; k<TILE_X; k++) {
            sum += A_shared[ty][k]*B_shared[k][tx];
        }
        __syncthreads();
    }

    C[row*N+col] = sum;
}

/*
 *  Use of cuBLAS
 */
void dmm_gpu_cublas(const value_t *A, const value_t *B, value_t *C,
		    const size_t M, const size_t N, const size_t K) {
  /*
   * source: https://solarianprogrammer.com/2012/05/31/matrix-multiplication-cuda-cublas-curand-thrust/
   */

    int lda = N;
    int ldb = K;
    int ldc = N;

    const float alf = 1;
    const float bet = 0;
    const float *alpha = &alf;
    const float *beta = &bet;

    cublasHandle_t handle;
    cublasCreate(&handle);

    cublasSgemm(handle, CUBLAS_OP_N, CUBLAS_OP_N, N, M, K, alpha, A, lda, B, ldb, beta, C, ldc);

    cublasDestroy(handle);
}
