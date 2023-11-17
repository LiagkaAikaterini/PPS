CC = gcc
CFLAGS = -Wall -Wextra -pthread

## Remove some warnings.
CFLAGS += -Wno-unused-parameter -Wno-unused-variable -Wno-unused-function

all: serial fine_grain optimistic lazy non_blocking

## Additional source files
SRC_FILES = ../common/aff.c

serial: main.c ll_serial.c ${SRC_FILES}
	$(CC) $(CFLAGS) $^ -o $@

fine_grain: main.c ll_fgl.c ${SRC_FILES}
	$(CC) $(CFLAGS) $^ -o $@

optimistic: main.c ll_opt.c ${SRC_FILES}
	$(CC) $(CFLAGS) $^ -o $@

lazy: main.c ll_lazy.c ${SRC_FILES}
	$(CC) $(CFLAGS) $^ -o $@

non_blocking: main.c ll_nb.c ${SRC_FILES}
	$(CC) $(CFLAGS) $^ -o $@

clean:
	rm -f serial fine_grain optimistic lazy non_blocking
