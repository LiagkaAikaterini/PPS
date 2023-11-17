CC=mpicc
CFLAGS=-O3 -lm -Wall
RES=-DPRINT_RESULTS
CONV=-DTEST_CONV

all: gssor

gssor: GSSOR_mpi.c utils.c
	$(CC) $(CFLAGS) $(RES) $(CONV) GSSOR_mpi.c utils.c -o gssor

clean:
	rm gssor
