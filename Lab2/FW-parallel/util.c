#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <sys/time.h>
#include "util.h"
#include <omp.h>

void graph_init_random(int **adjm, int seed, int n,  int m)
{
     unsigned  int i, j;

     srand48(seed);

     #pragma omp parallel for shared(adjm,n) private(i,j)
     for(i=0; i<n; i++)
        for(j=0; j<n; j++)
           adjm[i][j] = abs((( int)lrand48()) % 1048576);
     
     for(i=0; i<n; i++)adjm[i][i]=0;
}

