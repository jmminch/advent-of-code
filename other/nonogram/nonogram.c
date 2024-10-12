#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
  int n;
  int clues[256];
} clues;

typedef struct {
  int w, h;
  int guess;
  clues vclues[256];
  clues hclues[256];
  char cells[1];
} Board;

typedef struct {
  int groupPos[256];
  char line[1024];
  int solFound;
} SolveState;

Board *loadBoard( FILE *fp );
void parseClue( char *s, clues *clue );
int get( Board *b, int x, int y );
int set( Board *b, int x, int y, int v );
int guess( Board *b );
int solveBoard( Board *b );
int solveLine( int len, int *line, clues *clue );
int findSolution( int len, int *line, clues *clue );
int checkAddition( int len, int *line, clues *clue, int idx );
int checkValid( int len, int *line, clues *clue, int idx );

int solveLine2( int len, int *line, clues *clue );
void placeGroup( int len, int *line, clues *clue,
                 int clueIdx, int startPos,
                 SolveState *state );

void printBoard( Board *b );

Board *loadBoard( FILE *fp )
{
  int w;
  int h;
  char buf[4096];
  Board *b;

  fgets(buf, 4096, fp);
  h = atoi(buf);
  fgets(buf, 4096, fp);
  w = atoi(buf);
  b = malloc(sizeof(Board) + w * h);
  memset(b, 0, sizeof(Board) + w * h);
  
  b->h = h;
  b->w = w;

  for(int i = 0; i < h; i++) {
    fgets(buf, 4096, fp);
    parseClue(buf, &b->hclues[i]);
  }

  fgets(buf, 4096, fp);

  for(int i = 0; i < w; i++) {
    fgets(buf, 4096, fp);
    parseClue(buf, &b->vclues[i]);
  }

  return b;
}

void parseClue( char *s, clues *clue )
{
  int j;
  char *val;

  for(clue->n = 0, val = strtok(s, " ");
      val;
      val = strtok(NULL, " "), clue->n++) {
    clue->clues[clue->n] = atoi(val);
  }
}

int get( Board *b, int x, int y )
{
  return b->cells[y * b->w + x];
}

int set( Board *b, int x, int y, int v )
{
  b->cells[y * b->w + x] = v;
}

int guess( Board *b )
{
  int cellCount = b->w * b->h;
  int solved;
  Board *tmpBoard = malloc(sizeof(Board) + cellCount);
  int curGuess = b->guess++;

  for(int i = 0; i < cellCount; i++) {
    if(b->cells[i] == 0) {
      /* This cell has an unknown state, try guessing a state. */
      printf("guessing cell %d\n", i);

      for(int x = 1; x <= 2; x++) {
        memcpy(tmpBoard, b, sizeof(Board) + cellCount);
        tmpBoard->cells[i] = x;
        solved = solveBoard(tmpBoard);
        if(solved == cellCount) {
          /* Solution found. */
          memcpy(b, tmpBoard, sizeof(Board) + cellCount);
          free(tmpBoard);
          return solved;
        }

        if(solved == -1) {
          /* No possible solution for this guess. */
          continue;
        }

        /* This guess could work, but did not completely solve the puzzle;
         * recursively guess again. */
        guess(b);
      }

      /* Tried both states and neither works. */
      printf("guess %d failed\n", curGuess);
      b->guess--;
      free(tmpBoard);
      return -1;
    }
  }

  /* Should only happen if the entire board was already solved. */
  free(tmpBoard);
  return cellCount;
}

int solveBoard( Board *b )
{
  int solvedCells = 0;
  int line[1024];
  int cellCount = b->w * b->h;

  /* count already solved cells */
  for(int i = 0; i < cellCount; i++) {
    if(b->cells[i] != 0) solvedCells++;
  }
  
  while(solvedCells < cellCount) {

    int solved = 0;

    for(int x = 0; x < b->w; x++) {
      for(int y = 0; y < b->h; y++) line[y] = get(b, x, y);
      int c = solveLine2(b->h, line, &b->vclues[x]);
      if(c == -1) return -1; /* impossible */
      if(c > 0) {
        solved += c;
        for(int y = 0; y < b->h; y++) set(b, x, y, line[y]);
      }
    }

    for(int y = 0; y < b->h; y++) {
      for(int x = 0; x < b->w; x++) line[x] = get(b, x, y);
      int c = solveLine2(b->w, line, &b->hclues[y]);
      if(c == -1) return -1; /* impossible */
      if(c > 0) {
        solved += c;
        for(int x = 0; x < b->w; x++) set(b, x, y, line[x]);
      }
    }

    solvedCells += solved;
    printBoard(b);
    printf("\n\n");

    /* Bail out if this method doesn't result in anything. */
    if(solved == 0) break;
  }

  if(solvedCells < cellCount) {
    /* Recursively guess cells to try to solve the puzzle. */
    solvedCells = guess(b);
  }

  return solvedCells;
}

int solveLine( int len, int *line, clues *clue )
{
  int poss[1024] = { 0 };
  int work[1024];
  int solveCount = 0;

  for(int i = 0; i < len; i++) {
    if(line[i] > 0) continue;

    if(!(poss[i] & 1)) {
      memcpy(work, line, sizeof(int) * len);
      work[i] = 1;
      if(findSolution(len, work, clue)) {
        for(int j = 0; j < len; j++) poss[j] |= work[j];
      }
    }

    if(!(poss[i] & 2)) {
      memcpy(work, line, sizeof(int) * len);
      work[i] = 2;
      if(findSolution(len, work, clue)) {
        for(int j = 0; j < len; j++) poss[j] |= work[j];
      }
    }

    if(poss[i] != 3) {
      line[i] = poss[i];
      solveCount++;
    }
  }

  return solveCount;
}

int findSolution( int len, int *line, clues *clue )
{
  return checkAddition(len, line, clue, 0);
}

int checkAddition( int len, int *line, clues *clue, int idx )
{
  if(!checkValid(len, line, clue, idx)) return 0;
  if(idx == len) return 1;

  if(line[idx] > 0) {
    return checkAddition(len, line, clue, idx + 1);
  } else {
    line[idx] = 1;
    if(checkAddition(len, line, clue, idx + 1)) return 1;
    line[idx] = 2;
    if(checkAddition(len, line, clue, idx + 1)) return 1;
    line[idx] = 0;
    return 0;
  }
}

int checkValid( int len, int *line, clues *clue, int idx )
{
  int groupLen = 0;
  int cluePtr = 0;

  for(int i = 0; i < idx; i++) {
    if(line[i] == 1) {
      groupLen++;
      if(clue->clues[cluePtr] < groupLen) return 0;
    } else {
      if(groupLen > 0) {
        if(clue->clues[cluePtr] != groupLen) return 0;
        groupLen = 0;
        cluePtr++;
      }
    }
  }

  if(idx == len) {
    if(groupLen && clue->clues[cluePtr] != groupLen) return 0;
    cluePtr++;
    if(cluePtr != clue->n) return 0;
  }

  return 1;
}

int solveLine2( int len, int *line, clues *clue )
{
  SolveState state = { 0 };
  int solvedCells = 0;

  placeGroup(len, line, clue, 0, 0, &state);

  for(int pos = 0; pos < len; pos++) {
    if(line[pos] != 0) continue;
    if(state.line[pos] == 3) continue;
    solvedCells++;
    line[pos] = state.line[pos];
  }

  /* Indicate if this line can't be solved. */
  if(state.solFound == 0) return -1;

  return solvedCells;
}

void placeGroup( int len, int *line, clues *clue,
                 int clueIdx, int startPos,
                 SolveState *state )
{
  int endPos;
  int emptyLine = 0;

  int count = 0;
  for(int i = clueIdx + 1; i < clue->n; i++) count += clue->clues[i];
  count += clue->n - clueIdx - 1;
  endPos = len - count - clue->clues[clueIdx];

  for(int pos = startPos; pos <= endPos; pos++) {
    if(pos > 0 && line[pos - 1] == 1) break;
    
    for(int i = pos; i < pos + clue->clues[clueIdx]; i++) {
      if(line[i] == 2) goto SKIP;
    }

    if(clueIdx == clue->n - 1 && !emptyLine) {
      for(int i = pos + clue->clues[clueIdx]; i < len; i++) {
        if(line[i] == 1) goto SKIP;
      }
      emptyLine = 1;
    }

    state->groupPos[clueIdx] = pos;

    if(clueIdx == clue->n - 1) {
      int ptr, iClue;
      for(ptr = 0, iClue = 0; iClue < clue->n; iClue++) {
        for( ; ptr < state->groupPos[iClue]; ptr++)
          state->line[ptr] |= 2;
        for(int i = 0; i < clue->clues[iClue]; i++, ptr++)
          state->line[ptr] |= 1;
      }

      for( ; ptr < len; ptr++)
        state->line[ptr] |= 2;

      state->solFound = 1;
    } else {
      placeGroup(len, line, clue,
                 clueIdx + 1, pos + clue->clues[clueIdx] + 1,
                 state);
    }

    SKIP:
  }
}

void printBoard( Board *b )
{
  for(int y = 0; y < b->h; y++) {
    for(int x = 0; x < b->w; x++) {
      int c = get(b, x, y);
      printf("%c", (c == 0) ? '.' : ((c == 1) ? '#' : ' '));
    }
    printf("\n");
  }
}

int main( int argc, char **argv )
{
  Board *b = loadBoard(stdin);

  printf("size: %dx%d\n", b->w, b->h);
  solveBoard(b);
}
