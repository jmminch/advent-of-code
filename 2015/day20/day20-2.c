#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

int main( int argc, char **argv )
{
  uint32_t target = 29000000;
  uint32_t *houses;
  int maxhouse = 999999;

  if(argc > 1) {
    target = atoi(argv[1]);
  }

  houses = malloc(1000000 * sizeof(uint32_t));
  if(!houses) {
    printf("malloc failed!\n");
    return 1;
  }
  memset(houses, 0, 1000000 * sizeof(uint32_t));

  int elf = 0;

  while(houses[elf] < target) {
    int i, h;
    elf++;
    for(i = 0, h = elf; i < 50 && h <= maxhouse; i++, h += elf) {
      houses[h] += elf * 11;
      if(houses[h] > target) {
        maxhouse = h;
      }
    }
  }

  printf("part 2 result: %d\n", elf);
  return 0;
}
