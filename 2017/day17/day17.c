#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>

/* All the elements are are the 'next' pointers in the list. To start,
 * element 0 points to itself. */
uint32_t *initBuffer( int size )
{
  uint32_t *buf = malloc(sizeof(uint32_t) * size);
  buf[0] = 0;
  return buf;
}

void simulate( int loops, int steps, int *part1, int *part2 )
{
  uint32_t *buf = initBuffer(loops + 1);
  int ptr = 0;

  for(int i = 1; i <= loops; i++) {
    /* Move ptr forward steps times. */
    for(int j = 0; j < steps; j++) ptr = buf[ptr];

    /* insert value "i" after ptr */
    buf[i] = buf[ptr];
    buf[ptr] = i;

    /* Move ptr to i */
    ptr = i;
  }

  /* Element after the most recently added one. */
  if(part1) *part1 = buf[ptr];
  /* Element after element zero. */
  if(part2) *part2 = buf[0];

  free(buf);
  return;
}

int main( int argc, char **argv )
{
  int step = 329;
  int part1, part2;
  if(argc > 1) step = atoi(argv[1]);
  simulate(2017, step, &part1, NULL);
  printf("Part 1 result: %d\n", part1);
  simulate(50000000, step, NULL, &part2);
  printf("Part 2 result: %d\n", part2);
  return 0;
}
