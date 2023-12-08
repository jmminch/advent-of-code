#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include <string.h>

typedef struct {
  int next;
  int prev;
} Marble;

int main( int argc, char **argv )
{
  int maxMarble = 71944;
  int players = 423;
  int ptr;
  int player;

  Marble *marbles = NULL;
  int64_t *scores;

  if(argc > 1) maxMarble = atoi(argv[1]);

  marbles = malloc(sizeof(Marble) * (maxMarble + 1));
  scores = malloc(sizeof(int64_t) * players);
  memset(scores, 0, sizeof(int64_t) * players);

  /* Initialize the first marble */
  marbles[0].next = marbles[0].prev = 0;

  ptr = 0;  /* Current marble */
  player = 0;

  for(int id = 1; id <= maxMarble; id++) {
    if(id % 23) {
      /* Not divisible by 23. Place a new marble after the next marble in
       * the ring, and make that the new "current marble." */
      ptr = marbles[ptr].next;

      // initialize the new node
      marbles[id].next = marbles[ptr].next;
      marbles[id].prev = ptr;

      // Make the two marbles around it point to it
      marbles[marbles[ptr].next].prev = id;
      marbles[ptr].next = id;

      ptr = id;
    } else {
      /* Divisible by 23. */
      scores[player] += id;

      /* Move 7 marbles previous. */
      for(int i = 0; i < 7; i++) ptr = marbles[ptr].prev;

      /* Remove this marble. */
      marbles[marbles[ptr].prev].next = marbles[ptr].next;
      marbles[marbles[ptr].next].prev = marbles[ptr].prev;

      scores[player] += ptr;
      ptr = marbles[ptr].next;
    }

    /* Move to the next player. */
    player++;
    if(player >= players) player = 0;
  }

  /* Find the high score. */
  int64_t highScore = 0;
  for(int i = 0; i < players; i++) {
    if(scores[i] > highScore) highScore = scores[i];
  }

  printf("High score: %lld\n", highScore);
  return 0;
}
