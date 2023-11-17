#include "lock.h"
#include "../common/alloc.h"
#include <stdbool.h>

struct lock_struct {
	int size;
	int tail;
	bool *flag;
};

__thread int mySlotIndex;

lock_t *lock_init(int nthreads)
{
	lock_t *lock;

	XMALLOC(lock, 1);
	XMALLOC(lock->flag, nthreads);

	lock->size = nthreads;
	lock->tail = 0;
	for (int i=1; i<nthreads; i++)
		lock->flag[i] = false;
	lock->flag[0] = true;
	
	return lock;
}

void lock_free(lock_t *lock)
{
	XFREE(lock->flag);
	XFREE(lock);
}

void lock_acquire(lock_t *lock)
{
	int slot = __sync_fetch_and_add(&lock->tail, 1) % (lock->size);
	mySlotIndex = slot;
	while(!lock->flag[slot])
		/* do nothing */ ;	
}

void lock_release(lock_t *lock)
{
	int slot = mySlotIndex;
	lock->flag[slot] = false;
	lock->flag[(slot + 1) % (lock->size)] = true;
}
