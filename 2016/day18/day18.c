/* day18.c */

#include <stdio.h>
#include <stdint.h>

#define BV_MAX 4096  /* bits */

typedef struct {
  int len;
  uint8_t data[BV_MAX / 8];
} BitVector;

/* State for iterating through the vector */
typedef struct {
  int i; /* current bit accessed */
  uint8_t *bytePtr;
  uint8_t bitPtr;
} IState;

void initIState( BitVector *bv, IState *state )
{
  state->i = 0;
  state->bytePtr = bv->data;
  state->bitPtr = 0x1;
}

/* Return the next bit in the bit vector. */
int nextBit( BitVector *bv, IState *state )
{
  if(state->i >= bv->len) return -1;
  int r = (*state->bytePtr & state->bitPtr) ? 1 : 0;

  if(state->bitPtr < 0x80) {
    state->bitPtr <<= 1;
  } else {
    state->bitPtr = 0x1;
    state->bytePtr++;
  }
  return r;
}

/* Add a bit to the bit vector */
void addBit( BitVector *bv, IState *state, int val )
{
  bv->len++;
  if(val) {
    *state->bytePtr |= state->bitPtr;
  } else {
    *state->bytePtr &= ~state->bitPtr;
  }
  nextBit(bv, state);
}

void step( BitVector *curLine, BitVector *nextLine )
{
  /* Iterators for both lines. */
  IState cS, nS;

  /* Rules definition. The bits of the rules index are:
   * 4 - left tile
   * 2 - middle tile
   * 1 - right tile
   * If rules[idx] == 1, then the new tile is 1; otherwise 0. */
  uint8_t rules[8] = { [6] = 1, [3] = 1, [4] = 1, [1] = 1 };
  int cellState = 0;

  /* Reset nextLine */
  nextLine->len = 0;

  initIState(curLine, &cS);
  initIState(nextLine, &nS);

  /* Add an initial 0 ('.') */
  addBit(nextLine, &nS, 0);

  /* The initial cell state is the first three bits of curLine. */
  cellState = (nextBit(curLine, &cS) << 2) |
              (nextBit(curLine, &cS) << 1) |
              (nextBit(curLine, &cS));

  for(int i = 0; i < curLine->len - 2; i++) {
    addBit(nextLine, &nS, rules[cellState]);
    cellState = ((cellState << 1) & 0x7) | nextBit(curLine, &cS);
  }

  /* Add the final 0 ('.') */
  addBit(nextLine, &nS, 0);

  return;
}

/* Algorithm from
 * https://graphics.stanford.edu/~seander/bithacks.html#CountBitsSetParallel
 * Note that this assumes that there's no junk after the end of a partial
 * word at the end of the vector. Based on my code, that should be true.
 */
int countBits( BitVector *bv )
{
  int words = (bv->len + 31) / 32;
  int count = 0;
  uint32_t *wp = (uint32_t *)bv->data;
  for(int i = 0; i < words; i++, wp++) {
    uint32_t v = *wp;
    v = v - ((v >> 1) & 0x55555555);            // reuse input as temporary
    v = (v & 0x33333333) + ((v >> 2) & 0x33333333);     // temp
    count += ((v + (v >> 4) & 0xF0F0F0F) * 0x1010101) >> 24; // count
  }
  return count;
}

void readInput( BitVector *bv )
{
  char buf[BV_MAX + 1];
  IState bs;

  /* Read the input line */
  fgets(buf, BV_MAX, stdin);
  buf[BV_MAX] = '\0';

  initIState(bv, &bs);
  addBit(bv, &bs, 0);
  for(char *bp = buf; *bp; bp++) {
    if(*bp == '.') addBit(bv, &bs, 0);
    if(*bp == '^') addBit(bv, &bs, 1);
  }
  addBit(bv, &bs, 0);

  return;
}

/* Number of rounds for each part. Note that since the input line counts as
 * a line to count, the number of steps is one less than the number of lines
 * that the question asks for. */
#define P1_ROUNDS 39
#define P2_ROUNDS 399999

int main( int argc, char **argv )
{
  BitVector v1 = { 0 }, v2 = { 0 };
  int part1, part2;
  int safeCount;
  BitVector *cp = &v1, *np = &v2;

  readInput(&v1);

  /* Note that countBits returns the number of 'on' bits, and we're trying
   * to find the number of 'off' bits. Also need to subtract the two edge
   * squares since they aren't supposed to be counted. */
  safeCount = (v1.len - countBits(&v1)) - 2;

  for(int i = 1; i <= P2_ROUNDS; i++) {
    step(cp, np);
    safeCount += (np->len - countBits(np)) - 2;

    if(i == P1_ROUNDS) part1 = safeCount;

    /* Swap cp and np for the next step. */
    BitVector *tmp = cp;
    cp = np;
    np = tmp;
  }

  part2 = safeCount;

  printf("Part 1 result: %d\n", part1);
  printf("Part 2 result: %d\n", part2);

  return 0;
}
