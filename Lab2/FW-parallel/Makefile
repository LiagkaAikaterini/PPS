.phony: all clean

all: fw_tiled_parallel fw_recursive_parallel fw_p 

CC=gcc
CFLAGS= -Wall -O3 -fopenmp -Wno-unused-variable

HDEPS+=%.h

OBJS=util.o

fw_tiled_parallel: fw_tiled_parallel.c 
	$(CC) $(OBJS) fw_tiled_parallel.c -o fw_tiled_parallel $(CFLAGS)

fw_recursive_parallel: fw_recursive_parallel.c
	$(CC) $(OBJS) fw_recursive_parallel.c -o fw_recursive_parallel $(CFLAGS)

fw_p: fw_parallel_v1.c
	$(CC) $(OBJS) fw_parallel_v1.c -o fw_p $(CFLAGS)

%.o: %.c $(HDEPS)
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f *.o fw_tiled_parallel 

