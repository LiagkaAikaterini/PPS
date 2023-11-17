Steps
-----

1. Set the environment for compilation and execution with the TBBs library (gcc-6.3.0 + TBBs 2020 update 3) (on target machine!)
$ module load tbbz

2 Specify full paths in Makefile.include as appropriate:
i.e.,
$ cat Makefile.include
TBB_DIR = /home/parallel/pps/2021-2022/tbb/tbb_latest/
LIBRARY_VER = $(shell cat /home/parallel/pps/2021-2022/tbb/TBB_LATEST_LIB.TXT)

3. Make sure you link your program against libtbb and librt
(see given Makefiles)

4. Build user program
$ cd parallel_for
$ make

5. Run example
$ ./parallel_for 4 10000000

