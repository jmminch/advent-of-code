#include <stdio.h>
#include <stdlib.h>
#include <string.h>

char *board = NULL;
int boardLen = 0;
int bp = 0;  /* next location to add a number */
char part1[11] = { -1 };
int part2 = -1;
char *input = "540561";
char inputArray[1024];
int inputVal;
int inputLen;

void addRecipe( char val )
{
  if(bp >= boardLen) {
    /* Allocate more space for board. */
    boardLen = 1024 + boardLen * 2;
    board = realloc(board, boardLen);
  }
  board[bp++] = val;

  if(bp == inputVal + 10) {
    memcpy(part1, board + bp - 10, 10);
    part1[10] = '\0';
  }

  if(part2 < 0 && bp >= inputLen) {
    if(!memcmp(board + bp - inputLen, inputArray, inputLen)) {
      part2 = bp - inputLen;
    }
  }
}

int main( int argc, char **argv )
{
  int elf1 = 0, elf2 = 1;

  if(argc > 1) input = argv[1];
  inputVal = atoi(input);
  inputLen = strlen(input);
  for(int i = 0; i < inputLen; i++) {
    inputArray[i] = input[i] - '0';
  }

  addRecipe(3);
  addRecipe(7);

  while(part1[0] < 0 || part2 < 0) {
    int newRecipe = board[elf1] + board[elf2];
    if(newRecipe > 9) {
      addRecipe(1);
      newRecipe -= 10;
    }
    addRecipe(newRecipe);

    elf1 = (elf1 + 1 + board[elf1]) % bp;
    elf2 = (elf2 + 1 + board[elf2]) % bp;
  }

  /* convert part 1 result to printable digits */
  for(int i = 0; i < 10; i++) part1[i] += '0';
  printf("Part 1 result: %s\nPart 2 result: %d\n", part1, part2);
  return 0;
}
