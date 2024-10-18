/* day19.c */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct Elf Elf;

struct Elf {
  int id;
  Elf *next;
  Elf *prev;
};

/* Returns a pointer to elf 1 in a list of the given size. */
/* The elf list is a circular, doubly-linked list. */
Elf *buildElfList( int size )
{
  /* Allocate the memory for the list in one block. */
  Elf *buffer = malloc(sizeof(Elf) * size);
  Elf *ep = buffer;
  for(int i = 0; i < size; i++, ep++) {
    ep->id = i + 1;
    ep->next = (i < size - 1) ? ep + 1 : buffer;
    ep->prev = i ? ep - 1 : &buffer[size - 1];
  }
  return &buffer[0];
}

void removeElf( Elf *ep )
{
  ep->next->prev = ep->prev;
  ep->prev->next = ep->next;
}

int main( int argc, char **argv )
{
  int elves = 3014387;
  Elf *elfList, *elfPtr;
  int size;

  /* Get the number of elves from the command line, if specified. */
  if(argc > 1) {
    elves = atoi(argv[1]);
  }

  elfList = buildElfList(elves);
  elfPtr = elfList;
  size = elves;

  /* Part 1 - each step, remove the next elf in the list, until only one elf
   * remains. */
  while(size > 1) {
    removeElf(elfPtr->next);
    size--;
    elfPtr = elfPtr->next;
  }
  printf("Part 1 result: %d\n", elfPtr->id);

  free(elfList);

  elfList = buildElfList(elves);
  elfPtr = elfList;
  size = elves;

  /* Part 2 - each step, remove the elf that is directly across from the
   * current elf (<# of elves / 2> steps away). Since buildElfList creates
   * an array of all elves in order, the current elf that is directly across
   * from the first elf can be calculated without searching. (This won't be
   * true after we start removing elves from the list.) */

  Elf *rmvPtr = elfList + (elves / 2); /* The next elf to remove */

  while(size > 1) {
    removeElf(rmvPtr);

    /* The elf that is directly across from elfPtr will move to one of the
     * ones next to the one just removed; depending on the current number of
     * elves in the list. */
    if(size & 1) {
      /* odd size, rmvPtr moves to the next elf. */
      rmvPtr = rmvPtr->next;
    } else {
      /* even size, rmvPtr moves to the previous elf. */
      rmvPtr = rmvPtr->prev;
    }

    /* Move to the next elf */
    elfPtr = elfPtr->next;
    rmvPtr = rmvPtr->next;
    size--;
  }
  printf("Part 2 result: %d\n", elfPtr->id);

  free(elfList);

  return 0;
}
