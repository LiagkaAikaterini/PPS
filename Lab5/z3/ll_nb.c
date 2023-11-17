#include <stdio.h>
#include <stdlib.h> /* rand() */
#include <limits.h>
#include <stdbool.h>

#include "../common/alloc.h"
#include "ll.h"

typedef struct ll_node {
	int key;
	struct ll_node *next;
	/* other fields here? */
} ll_node_t;

struct linked_list {
	ll_node_t *head;
	/* other fields here? */
};

typedef struct ll_window {
	ll_node_t *prev;
	ll_node_t *curr;
} ll_window_t;


ll_window_t *ll_window_new(ll_node_t *myPrev, ll_node_t *myCurr)
{
	ll_window_t *ret;

        XMALLOC(ret, 1);
	ret->prev = myPrev;
	ret->curr = myCurr;

	return ret;
}
        

/**
 * Create a new linked list node.
 **/
static ll_node_t *ll_node_new(int key)
{
	ll_node_t *ret;

	XMALLOC(ret, 1);
	ret->key = key;
	ret->next = NULL;
	/* Other initializations here? */

	return ret;
}

/**
 * Free a linked list node.
 **/
static void ll_node_free(ll_node_t *ll_node)
{
	XFREE(ll_node);
}

/**
 * Create a new empty linked list.
 **/
ll_t *ll_new()
{
	ll_t *ret;

	XMALLOC(ret, 1);
	ret->head = ll_node_new(-1);
	ret->head->next = ll_node_new(INT_MAX);
	ret->head->next->next = NULL;

	return ret;
}

/**
 * Free a linked list and all its contained nodes.
 **/
void ll_free(ll_t *ll)
{
	ll_node_t *next, *curr = ll->head;
	while (curr) {
		next = curr->next;
		ll_node_free(curr);
		curr = next;
	}
	XFREE(ll);
}

ll_node_t *get(ll_node_t *node, bool *marked) 
{
	ll_node_t *res;

	*marked = (bool) ( (unsigned long long)node & 1 );
	res = (ll_node_t *) ( (unsigned long long)node & (~1) );

	return res;
}

ll_node_t *getReference(ll_node_t *node)
{
	ll_node_t *res;

	res = (ll_node_t *) ( (unsigned long long)node & (~1) );

	return res;
}

bool compareAndSet(ll_node_t *node, ll_node_t *expectedRef, ll_node_t *updateRef, bool expectedMark, bool updateMark)
{
	bool res;
	ll_node_t *expectedNode, *updateNode;

	expectedNode = (ll_node_t *) ( (unsigned long long)expectedRef | expectedMark );
	updateNode = (ll_node_t *) ( (unsigned long long)updateRef | updateMark );

	res = __sync_bool_compare_and_swap(&node, expectedNode, updateNode);

	return res;	
}

ll_window_t *ll_find(ll_t *ll, int key)
{
	ll_node_t *prev, *curr, *succ;
	bool marked, snip;
	ll_window_t *res;

	prev = NULL;
	curr = NULL;
	succ = NULL;
	marked = false;

retry:
	while (true) {
		prev = ll->head;
		curr = getReference(prev->next);
		
		while (true) {
			succ = get(curr->next, &marked);

			while (marked) {
				snip = compareAndSet(prev->next, curr, succ, false, false);
				if (!snip)
					goto retry;
				curr = succ;
				succ = get(curr->next, &marked);
			}
			
			if (curr->key >= key) {
				res = ll_window_new(prev, curr);
				return res;
			}
			prev = curr;
			curr = succ;
		}
	}
}

int ll_contains(ll_t *ll, int key)
{
	bool marked;
	ll_node_t *curr;
	
	curr = ll->head;
	while (curr->key < key) {
		curr = getReference(curr->next);
	}
	get(curr->next, &marked);

	return (curr->key == key && !marked);
}

int ll_add(ll_t *ll, int key)
{
	bool splice;
	ll_window_t *myWindow;
	ll_node_t *prev, *curr, *new_node;

	while (true) {
		myWindow = ll_find(ll, key);
		prev = myWindow->prev;
		curr = myWindow->curr;
		XFREE(myWindow);
		
		if (curr->key == key)
			return false;
		else {
			new_node = ll_node_new(key);
			new_node->next = curr;
			if ( compareAndSet(prev->next, curr, new_node, false, false) )
				return true;
		}
	}
}

int ll_remove(ll_t *ll, int key)
{
	bool snip;
	ll_window_t *myWindow;
	ll_node_t *prev, *curr, *succ;

	while (true) {
		myWindow = ll_find(ll, key);
		prev = myWindow->prev;
		curr = myWindow->curr;
		XFREE(myWindow);

		if (curr->key != key)
			return false;
		else {
			succ = getReference(curr->next);
			snip = compareAndSet(curr->next, succ, succ, false, true);
			if (!snip)
				continue;
			compareAndSet(prev->next, curr, succ, false, false);
			return true;
		}
	}
}

/**
 * Print a linked list.
 **/
void ll_print(ll_t *ll)
{
	ll_node_t *curr = ll->head;
	printf("LIST [");
	while (curr) {
		if (curr->key == INT_MAX)
			printf(" -> MAX");
		else
			printf(" -> %d", curr->key);
		curr = curr->next;
	}
	printf(" ]\n");
}
