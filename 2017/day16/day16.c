#include <stdio.h>
#include <strings.h>
#include <string.h>
#include <stdint.h>
#include <stdlib.h>

/* max input size */
#define BUFSIZE (1024 * 1024)
/* max number of dance instructions */
#define MAX_INST 50000

typedef struct {
  char op;
  uint8_t arg1;
  uint8_t arg2;
  uint8_t pad;
} inst;

char danceBuf[BUFSIZE];
inst dance[MAX_INST];

void readDance( void );
void doDance( char *list );
void spin( char *list, uint8_t size );
void exchange( char *list, uint8_t idx1, uint8_t idx2 );
void partner( char *list, uint8_t val1, uint8_t val2 );

int main( int argc, char **argv )
{
  char list[17];
  int numIterations = -1;
  readDance();
  strcpy(list, "abcdefghijklmnop");
  doDance(list);
  printf("Part 1 result: %s\n", list);
  for(int i = 0; i < 999999; i++) {
    doDance(list);
    if(!strcmp(list, "abcdefghijklmnop")) {
      /* Loop found! */
      printf("Loops after %d iterations.\n", i + 2);
      numIterations = 1000000000 % (i + 2);
      break;
    }
  }

  if(numIterations == -1) {
    printf("No loop found!\n");
    exit(1);
  }

  /* Note that because we broke the prior loop when we were back to the
   * starting point, the list is in the original order. */
  for(int i = 0; i < numIterations; i++)
    doDance(list);

  printf("Part 2 result: %s\n", list);
  return 0;
}

void readDance( void )
{
  int i;
  char *dp;

  if(fgets(danceBuf, BUFSIZE, stdin) == NULL) {
    fprintf(stderr, "couldn't read input line.\n");
    exit(1);
  }

  /* Read the list of instructions. */
  for(i = 0, dp = danceBuf; dp; i++) {
    dance[i].op = dp[0];
    switch(dp[0]) {
      case 's':
        dance[i].arg1 = atoi(dp + 1);
        break;
      case 'x':
        dance[i].arg1 = atoi(dp + 1);
        dance[i].arg2 = atoi(index(dp, '/') + 1);
        break;
      case 'p':
        dance[i].arg1 = dp[1];
        dance[i].arg2 = dp[3];
        break;
    }
    dp = index(dp, ',');
    if(dp) {
      dp++;
    }
  }
  dance[i].op = '\0'; /* mark end of list. */
}

void doDance( char *list )
{
  for(int i = 0; dance[i].op; i++) {
    if(dance[i].op == 's') {
      spin(list, dance[i].arg1);
    } else if(dance[i].op == 'x') {
      exchange(list, dance[i].arg1, dance[i].arg2);
    } else { /* 'p' */
      partner(list, dance[i].arg1, dance[i].arg2);
    }
  }
}

/* Move the last "size" elements from the end of the list to the beginning. */
void spin( char *list, uint8_t size )
{
  char tmp[16];
  memcpy(tmp, list, 16);
  memcpy(list, tmp + (16 - size), size);
  memcpy(list + size, tmp, (16 - size));
}

/* swap elements at index idx1 and idx2 */
void exchange( char *list, uint8_t idx1, uint8_t idx2 )
{
  char tmp = list[idx1];
  list[idx1] = list[idx2];
  list[idx2] = tmp;
}

/* swap elements by value */
void partner( char *list, uint8_t val1, uint8_t val2 )
{
  uint8_t idx1, idx2;
  for(idx1 = 0; list[idx1] != val1; idx1++) { }
  for(idx2 = 0; list[idx2] != val2; idx2++) { }
  exchange(list, idx1, idx2);
}
