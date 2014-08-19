#include <stdio.h>
#include <string.h>

struct heap {
	int array[32];
	int size;
	int max;
};

typedef struct heap heap_t;

int heap_init(heap_t *h, int max)
{
	h->size=0;
	h->max = max;
  
	return 0;
}

heap_t *heap_create(int max)
{
	heap_t *h;
	h = malloc(sizeof(heap_t));
	heap_init(h, max);
	return h;
}


int heap_empty(heap_t *h)
{
	return h->size == 0;
}

int heap_full(heap_t *h)
{
	return h->size == h->max;
}

void heap_insert(heap_t *h, int x)
{
	int i;

	if (heap_full(h)) {
		printf("Full\n");
		return;
	}

	for (i=h->size++; i>0 && h->array[(i-1)/2] > x;i=(i-1)/2)
		h->array[i] = h->array[(i-1)/2];
  

	h->array[i] = x;
}


int heap_delete(heap_t *h)
{

	int min, last;
	int i, j;

	if (heap_empty(h))
		return;


	min=h->array[0];
	last = h->array[--h->size];

	for (i=0; i*2+1<h->size; i=j) {
		j = i*2 + 1;
    
		if ( j!= h->size -1 && h->array[j+1] < h->array[j]) 
			j++;

		if (last > h->array[j]) 
			h->array[i] = h->array[j];
		else
			break;
	}

	h->array[i] = last;
	return min;
}


///////////////////////////////

int test_data[] = {
	11, 10, 9, 6, 7, 8, 10, 64, 
	45, 46, 47, 48, 1, 2, 3, 4, 
	25, 24, 23, 22, 100, 101, 102, 10, 
	103, 104, 105, 106, 13, 14, 15, 16};
   


int main()
{
	int i;

	heap_t *h = heap_create(32);

	for(i=0;i<31;i++) {
		heap_insert(h, test_data[i]);
	}

	while(!heap_empty(h)) {
		printf("%d\n", heap_delete(h));
	}

}
