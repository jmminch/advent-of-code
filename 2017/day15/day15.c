#include <stdint.h>
#include <stdio.h>

uint32_t genA;
uint32_t genB;

/* These are standard Lehmer RNG values. */
uint32_t genA_next()
{
  /* Need to use 64-bit arithmetic to avoid overflow. */
  genA = ((uint64_t)genA * 16807) % 2147483647;
  return genA;
}

uint32_t genB_next()
{
  genB = ((uint64_t)genB * 48271) % 2147483647;
  return genB;
}

int part1( void )
{
  int i;
  int part1 = 0;
  for(i = 0; i < 40000000; i++) {
    genA_next();
    genB_next();
    if((genA & 0xFFFF) == (genB & 0xFFFF)) {
      part1++;
    }
  }
  return part1;
}

int part2( void )
{
  int i;
  int part2 = 0;
  for(i = 0; i < 5000000; i++) {
    do {
      genA_next();
    } while((genA % 4) != 0);
    do {
      genB_next();
    } while((genB % 8) != 0);
    if((genA & 0xFFFF) == (genB & 0xFFFF)) {
      part2++;
    }
  }
  return part2;
}

int main( int argc, char **argv )
{
  /* Seed values from the puzzle input. */
  genA = 703;
  genB = 516;
  printf("Part 1 result: %d\n", part1());

  /* Reset seeds for part 2. */
  genA = 703;
  genB = 516;
  printf("Part 2 result: %d\n", part2());
  return 0;
}
