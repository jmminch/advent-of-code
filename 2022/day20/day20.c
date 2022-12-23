#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>

int listLen = 0;
int64_t values[10000]; /* actual length of input is up to 5000 */
uint16_t refs[10000];

void printList( void )
{
  for(int i = 0; i < listLen; i++) {
    printf("%d, ", values[refs[i]]);
  }
  printf("\n");
}

/* load the input values from stdin */
void loadValues( void )
{
  char buf[128];
  while(fgets(buf, 127, stdin)) {
    if(buf[0] == '-' || isdigit(buf[0])) {
      values[listLen] = atoi(buf);
      listLen++;
    }
  }

  for(int i = 0; i < listLen; i++) {
    refs[i] = (uint16_t)i;
  }
}

int findRef( int reference )
{
  for(int idx = 0; idx < listLen; idx++) {
    if((uint16_t)reference == refs[idx]) return idx;
  }
  return -1;
}

void moveElement( int from, int to )
{
  if(from > to) {
    /* move everything from to->(from - 1) up 1, and then place what was in
     * 'from' at 'to'. */
    uint16_t tmp = refs[from];
    memmove(refs + to + 1, refs + to, (from - to) * sizeof(uint16_t));
    refs[to] = tmp;
  } else {
    /* move everything from (from + 1)->to back 1, then place what was in
     * 'from' at 'to'. */
    uint16_t tmp = refs[from];
    memmove(refs + from, refs + from + 1, (to - from) * sizeof(uint16_t));
    refs[to] = tmp;
  }
}

void mix( void )
{
  int modulo = listLen - 1;

  //printList();

  for(int i = 0; i < listLen; i++) {
    int idx = findRef(i);
    int rot = values[refs[idx]] % modulo;
    if(rot == 0) continue;
    if(rot < 0) rot += modulo; /* make sure we're using a positive number. */
    int tgt = (idx + rot) % modulo;

    moveElement(idx, tgt);

    //printList();
  }

}

int main( int argc, char **argv )
{
  int64_t part1, part2;
  int zeroIdx;

  loadValues();
  mix();

  for(zeroIdx = 0; values[refs[zeroIdx]] != 0; zeroIdx++) { }
  part1 = values[refs[(zeroIdx + 1000) % listLen]] +
          values[refs[(zeroIdx + 2000) % listLen]] +
          values[refs[(zeroIdx + 3000) % listLen]];
  printf("Part 1 result: %lld\n", part1);

  /* Set up for part 2. */
  for(int i = 0; i < listLen; i++) {
    values[i] *= 811589153LL;
    refs[i] = (uint16_t)i;
  }

  /* mix ten times */
  for(int i = 0; i < 10; i++) {
    mix();
  }

  /* Same calculation for part 2. */
  for(zeroIdx = 0; values[refs[zeroIdx]] != 0; zeroIdx++) { }
  part2 = values[refs[(zeroIdx + 1000) % listLen]] +
          values[refs[(zeroIdx + 2000) % listLen]] +
          values[refs[(zeroIdx + 3000) % listLen]];
  printf("Part 2 result: %lld\n", part2);

  return 0;
}
