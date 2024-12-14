#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

struct cacheEntry {
  uint64_t v;
  int steps;
  uint64_t r;
};

#define CACHE_SIZE 1024*1024
#define HASH(v,s) (((v) * 87 + (s)) % CACHE_SIZE)

struct cacheEntry cache[CACHE_SIZE] = { 0 };

uint64_t splitVal( uint64_t v )
{
  if(v < 10) return 0;
  if(v < 100) return 10;
  if(v < 1000) return 0;
  if(v < 10000) return 100;
  if(v < 100000) return 0;
  if(v < 1000000) return 1000;
  if(v < 10000000) return 0;
  if(v < 100000000) return 10000;
  if(v < 1000000000) return 0;
  if(v < 10000000000) return 100000;
  if(v < 100000000000) return 0;
  if(v < 1000000000000) return 1000000;
  if(v < 10000000000000) return 0;
  if(v < 100000000000000) return 10000000;
}

uint64_t countStones( uint64_t v, int steps )
{
  uint64_t r = 0;
  
  int entry = HASH(v, steps);

  if(steps == 0) return 1; 

  if(cache[entry].v == v && cache[entry].steps == steps) {
    return cache[entry].r;
  } else if(cache[entry].v || cache[entry].steps) {
    entry == -1;
  }

  if(v == 0) { r = countStones(1, steps - 1); goto done; }

  uint64_t x = splitVal(v);
  if(x) {
    uint64_t a = v % x;
    uint64_t b = v / x;
    r = countStones(a, steps - 1) + countStones(b, steps - 1);
    goto done;
  }

  r = countStones(v * 2024, steps - 1);

  done:

  if(entry != -1) {
    cache[entry].v = v;
    cache[entry].steps = steps;
    cache[entry].r = r;
  }

  return r;
}

int main(int argc, char **argv) {
  uint64_t part1 = 0;
  uint64_t part2 = 0;
  for(int i = 1; i < argc; i++) {
    int v = atoi(argv[i]);
    part1 += countStones(v, 25);
    part2 += countStones(v, 75);
  }
  printf("Part 1 result: %lld\n", part1);
  printf("Part 2 result: %lld\n", part2);
  return 0;
}
