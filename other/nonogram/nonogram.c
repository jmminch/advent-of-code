#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

#define maxLineLen 256

/* Structures used for variable-length arrays. */
typedef struct {
  int len;
  int a[maxLineLen];
} IntArray;

typedef struct {
  int len;
  char a[maxLineLen];
} CharArray;

typedef struct {
  int w, h;
  int guess;

  /* seqNum is the incremented every time a cell is updated. */
  int seqNum;
  /* Element 0 of the Seq array is the seqNum when this line was last
   * processed.
   * Element 1 is the seqNum when this line was updated.
   * This is used to determine whether the line needs to be processed again. */
  int vSeq[maxLineLen][2];
  int hSeq[maxLineLen][2];

  /* vGroup[x] is the list of groups (clues) for column x;
   * hGroup[y] for row y. */
  IntArray vGroup[maxLineLen];
  IntArray hGroup[maxLineLen];

  /* The cells array contains the state of all cells of the board;
   * the cell at x, y is cells[x + y * b->w]
   * The valid states:
   * 0 - state is unknown (may be marked or unmarked)
   * 1 - known to be marked
   * 2 - known to be unmarked */
  char cells[];
} Board;

Board *loadBoard( FILE *fp );
void parseClue( char *s, IntArray *out );
char get( Board *b, int x, int y );
int set( Board *b, int x, int y, char v );

int guessCell( Board *b );
int guessGroup( Board *b );
int solveBoard( Board *b );

/* Structures and functions for the line solver. */
typedef struct {
  /* The position of each group that the solver is currently evaluating. */
  int groupPos[maxLineLen];

  /* The possible states for each cell:
   * 0 - starting state
   * 1 - may be marked
   * 2 - may be unmarked
   * 3 - may be either
   * Since state 1 is marked and state 2 is unmarked, just need to OR in the
   * value of each cell whenever a solution is found. If solutions are found
   * with this cell in both states, then the result will be 3. */
  char cellState[maxLineLen];

  /* Caches the results of calling placeGroup with a particular group index
   * and starting position. Once a particular combination has been
   * evaluated, then the evaluation doesn't need to be repeated during this
   * pass of the solver.
   * cache[groupIdx][startPos] will be set to:
   *   0 - empty (not called for this combination yet)
   *   1 - invalid position
   *   2 - valid position */
  char cache[maxLineLen][maxLineLen];
} SolveState;


int solveLine2( CharArray *line, IntArray *clue );
int placeGroup( CharArray *line, IntArray *clue,
                int groupIdx, int startPos,
                SolveState *state );
void markCells( SolveState *state, IntArray *clue,
                int nGroup, int nCell );

void printBoard( Board *b );

/* Load a .CWD file and return a Board structure. */
Board *loadBoard( FILE *fp )
{
  int w;
  int h;
  char buf[4096];
  Board *b;

  /* Lines 1-2 are the height and width */
  fgets(buf, 4096, fp);
  h = atoi(buf);
  fgets(buf, 4096, fp);
  w = atoi(buf);

  /* The cells[] field is flexible array; allocate enough memory for all the
   * cells of the board. */
  b = malloc(sizeof(Board) + w * h);
  memset(b, 0, sizeof(Board) + w * h);
  
  b->h = h;
  b->w = w;

  /* Read the horizontal row clues; one clue (so one row) per line. */
  for(int i = 0; i < h; i++) {
    fgets(buf, 4096, fp);
    parseClue(buf, &b->hGroup[i]);
  }

  /* Blank line between the horizontal and vertical clues. */
  fgets(buf, 4096, fp);

  /* Read the vertical column clues. */
  for(int i = 0; i < w; i++) {
    fgets(buf, 4096, fp);
    parseClue(buf, &b->vGroup[i]);
  }

  return b;
}

/* Parse a clue line (list of group lengths for one line) and
 * store in an IntArray structure. */
void parseClue( char *s, IntArray *out )
{
  char *val;

  for(out->len = 0, val = strtok(s, " ");
      val;
      val = strtok(NULL, " "), out->len++) {
    out->a[out->len] = atoi(val);
  }
}

/* Return the value of the cell at (x,y) */
char get( Board *b, int x, int y )
{
  return b->cells[y * b->w + x];
}

/* Set the value of the cell at (x,y).
 * Returns 1 if the cell was changed, 0 if not. */
int set( Board *b, int x, int y, char v )
{
  int cell = y * b->w + x;
  if(b->cells[cell] != v) {
    b->cells[cell] = v;

    /* Set vSeq[x/y][1] to the current sequence number to track the last
     * time this column/row was updated. This is used to determine whether
     * each line needs to be reprocessed by the solver. */
    b->vSeq[x][1] = b->seqNum;
    b->hSeq[y][1] = b->seqNum;
    b->seqNum++;

    return 1;
  }
  return 0;
}

/* Extract a single column or row into a CharArray structure for processing. */
void extractCol( Board *b, int x, CharArray *out )
{
  for(int y = 0, cp = x; y < b->h; y++, cp += b->w) {
    out->a[y] = b->cells[cp];
  }
  out->len = b->h;
}

void extractRow( Board *b, int y, CharArray *out )
{
  memcpy(out->a, b->cells + y * b->w, b->w);
  out->len = b->w;
}


/* Find a solution to the board.
 * The board may already have some cells filled in.
 * If the line-based solver can't find a solution, then it will call
 * guessGroup(b) to guess the location of one group and try again.
 * Returns 1 if a solution is found; 0 if no solution exists. */
int solveBoard( Board *b )
{
  int solvedCells = 0;
  int cellCount = b->w * b->h;
  CharArray line;

  /* count already solved cells */
  for(int i = 0; i < cellCount; i++) {
    if(b->cells[i] != 0) solvedCells++;
  }

  while(solvedCells < cellCount) {

    int solved = 0;

    /* Loop through all the rows. */
    for(int y = 0; y < b->h; y++) {
      /* Skip this row if it hasn't been changed since the last time it was
       * processed. */
      if(b->hSeq[y][0] && b->hSeq[y][0] >= b->hSeq[y][1]) {
        continue;
      }

      extractRow(b, y, &line);
      int c = solveLine2(&line, &b->hGroup[y]);
        
      if(c == -1) return 0; /* No solution for this board. */

      if(c > 0) {
        /* Some new cells were solved. Copy the cell data to the board. */
        solved += c;
        for(int x = 0; x < b->w; x++) set(b, x, y, line.a[x]);
      }

      /* Update the time when this row was processed.
       * This has to happen after the set() calls since that call updated
       * the row/column sequence numbers. */
      b->hSeq[y][0] = b->seqNum;

    }

    /* Loop through all the columns. */
    for(int x = 0; x < b->w; x++) {
      /* Skip this col if it hasn't been changed since the last time it was
       * processed. */
      if(b->vSeq[x][0] && b->vSeq[x][0] >= b->vSeq[x][1]) {
        continue;
      }

      extractCol(b, x, &line);
      int c = solveLine2(&line, &b->vGroup[x]);

      if(c == -1) return 0; /* No solution for this board. */

      if(c > 0) {
        solved += c;
        for(int y = 0; y < b->h; y++) set(b, x, y, line.a[y]);
      }

      /* Update the time when this col was processed.
       * This has to happen after the set() calls since that call updated
       * the row/column sequence numbers. */
      b->vSeq[x][0] = b->seqNum;
    }

    solvedCells += solved;
    //printBoard(b);
    //printf("\n\n");

    if(solved == 0) break;
  }

  if(solvedCells < cellCount) {
    /* Recursively guess cells to try to solve the puzzle. */
    return guessGroup(b);
  } else {
    return 1;
  }
}

/* Guess the state of a single unknown cell and then call solveBoard to
 * try to find a solution.
 * Returns 0 for no valid solution, or 1 if the board was solved. */
int guessCell( Board *b )
{
  int cellCount = b->w * b->h;
  int cell;

  for(cell = 0; cell < cellCount; cell++)
    if(b->cells[cell] == 0) break;  /* Found an unknown cell. */

  if(cell == cellCount) return 1;  /* Board was already fully solved. */

  int curGuess = ++b->guess;
  int y = cell / b->w;
  int x = cell % b->w;
  
  //printf("guess %d - guessing cell %d,%d\n", curGuess, x, y);

  Board *tmpBoard = malloc(sizeof(Board) + cellCount);

  int g;
  for(g = 1; g <= 2; g++) {  /* guess 1 (marked) followed by 2 */
    /* Make a working copy of the board since we may need to return to
     * the original state. */
    memcpy(tmpBoard, b, sizeof(Board) + cellCount);
    
    /* Set the value of the "guessed" cell. */
    set(tmpBoard, x, y, g);

    int s = solveBoard(tmpBoard);
    if(s) {
      /* Solution found; copy from the working copy to the original board
       * structure. */
      memcpy(b, tmpBoard, sizeof(Board) + cellCount);
      break;
    } 

    /* Otherwise, no solution for this guess. */
  }

  free(tmpBoard);

  if(g > 2) {
    /* Tried both states and neither works. */
    //printf("guess %d failed\n", curGuess);
    b->guess--;
    return 0;
  } else {
    return 1;
  }
}

/* Guess the location of a group of marked cells and then call solveBoard to
 * try to find a solution.
 * Returns 0 for no valid solution, or 1 if the board was solved. */
int guessGroup( Board *b )
{
  int cellCount = b->w * b->h;
  int cell;

  for(cell = 0; cell < cellCount; cell++)
    if(b->cells[cell] == 0) break;  /* Found an unknown cell. */

  if(cell == cellCount) return 1;  /* Board was already fully solved. */

  int curGuess = ++b->guess;
  int yu = cell / b->w;
  int xu = cell % b->w;

  if(curGuess > 500) {
    /* Bail out to prevent eating up all the memory. */
    return 0;
  }

  /* Work through any known cells at the beginning of the line, determining
   * which groups are already known.
   * Any marked cells which are known are expected to correspond with
   * fully-marked groups, because solveBoard should have been able to fill
   * out any groups in this range. */ 
  int groupIdx = 0;
  IntArray *clue = &(b->hGroup[yu]);
  CharArray line;

  extractRow(b, yu, &line);

  for(int i = 0; i < xu; i++) {
    if(line.a[i] == 1) {
      int j;
      for(j = i + 1; j < xu && line.a[j] == 1; j++) { }
      
      if(j == xu) {
        /* The last known cell is marked. This is unexpected. Fall back onto
         * the cell-by-cell guess function. */
        return guessCell(b);
      }

      if(j - i != clue->a[groupIdx]) {
        /* Known cells don't match the clues. Shouldn't happen. */
        return 0;
      }

      i = j + 1;
      groupIdx++;
    }
  }

  /* Now groupIdx is set the the index of the first fully-known group on
   * this line. It must start at offset xu or greater. */

  int startPos = xu;

  /* Determine the last possible position for the group, based on the
   * remaining groups that need to be placed in this line. This is the same
   * logic used in placeGroup(). */
  int count = 0;
  /* Sum up the lengths of the remaining groups, plus one for the separating
   * space. */
  for(int i = groupIdx + 1; i < clue->len; i++) count += clue->a[i] + 1;
  int endPos = line.len - count - clue->a[groupIdx];

  //printf("guess %d - row %d, group %d, %d-%d\n",
  //       curGuess, yu, groupIdx, startPos, endPos);

  Board *tmpBoard = malloc(sizeof(Board) + cellCount);

  /* Try positions for the group between startPos and endPos */
  for(int i = startPos; i <= endPos; i++) {

    /* Make a working copy of the board since we may need to return to
     * the original state. */
    memcpy(tmpBoard, b, sizeof(Board) + cellCount);

    /* Set all cells from startPos to the one past the group appropriately.
     * All of the cells before the group must be unmarked, as must the one
     * after the group. */
    int x;
    for(x = startPos; x < i; x++) {
      if(line.a[x] == 1) {
        /* An earlier cell is marked, so this group cannot be placed here or
         * at any further cell. Break out of the loop. */
        i = line.len;
        goto skip;
      }
      set(tmpBoard, x, yu, 2);
    }

    /* Mark cells within the group as marked. */
    for(int j = 0; j < clue->a[groupIdx]; j++, x++) {
      if(line.a[x] == 2) {
        /* A cell within this range is unmarked. */
        goto skip;
      }
      set(tmpBoard, x, yu, 1);
    }

    /* Set the cell following the group unmarked (unless this group is at
     * the end of the line) */
    if(x < line.len) {
      if(line.a[x] == 1) goto skip;
      set(tmpBoard, x, yu, 2);
    }

    /* Now call solveBoard to find a solution. */
    int r = solveBoard(tmpBoard);
    if(r) {
      /* Solution found */
      memcpy(b, tmpBoard, sizeof(Board) + cellCount);
      free(tmpBoard);
      return 1;
    }

    skip:
  }

  free(tmpBoard);
  //printf("guess %d failed\n", curGuess);
  b->guess--;
  return 0;
}


/* solveLine2
 * Infer as much information about this line as possible about this line.
 * Update the line[] array with any cells that have been solved.
 * Returns the number of cells that were solved by this call (unknown at the
 * beginning, and now known.)
 * Returns -1 if there is no valid solution for this line. */
int solveLine2( CharArray *line, IntArray *clue )
{
  SolveState state = { 0 };
  int solvedCells = 0;

  /* Try all possible placements for all groups, starting with group 0. */

  if(placeGroup(line, clue, 0, 0, &state)) {

    /* placeGroup returned 1, so the results are valid. */

    /* The state.cellState array contains information about the possible
     * states for each cell - marked, unmarked, or either. For any cell that
     * was unknown (line[pos] == 0), if the cell can be determined to be
     * either marked or unmarked, then update line[pos] to reflect the
     * required state for this cell. */
    for(int pos = 0; pos < line->len; pos++) {
      if(line->a[pos] != 0) continue;
      if(state.cellState[pos] == 3) continue;
      solvedCells++;
      line->a[pos] = state.cellState[pos];
    }

    return solvedCells;
  } else {
    /* placeGroup returned 0. There is no valid solution for this line. */
    return -1;
  }
}

int placeGroup( CharArray *line, IntArray *clue,
                int groupIdx, int startPos,
                SolveState *state )
{
  int valid = 0;
  int endPos;
  int emptyLine = 0;

  if(state->cache[groupIdx][startPos]) {
    /* Already analyzed this combination of clue and starting position.
     * If it was valid, then mark any cells prior to this startPos. */
    valid = state->cache[groupIdx][startPos] - 1;
    if(valid) {
      markCells(state, clue, groupIdx, startPos);
    }
    return valid;
  }

  /* Determine the last valid starting position for this group. */
  int count = 0;
  /* Sum up the lengths of the remaining groups, plus one for the separating
   * space. */
  for(int i = groupIdx + 1; i < clue->len; i++) count += clue->a[i] + 1;
  endPos = line->len - count - clue->a[groupIdx];

  /* Try placing the group at each location from startPos to endPos. */
  for(int pos = startPos; pos <= endPos; pos++) {

    /* If the cell before this one is set, then this is not a valid location
     * for this cell to start; it also cannot be placed at any greater
     * position since the previous groups have already been placed. */
    if(pos > 0 && line->a[pos - 1] == 1) break;
    
    /* Check whether any of the cells within this group are known unmarked;
     * if so then skip over that cell. */
    for(int j = 0, x = pos; j < clue->a[groupIdx]; j++, x++) {
      if(line->a[x] == 2) {
        goto skip;
      }
    }

    /* If this is the last clue, then there cannot be any marked cells after
     * this group.
     * If emptyLine is set, then we've already checked and found that the
     * remainder of the line is empty.
     * Work backwards to be slightly more efficient. */
    if(groupIdx == clue->len - 1 && !emptyLine) {
      for(int x = line->len - 1; x >= pos + clue->a[groupIdx]; x--) {
        if(line->a[x] == 1) {
          /* Found a known-marked cell. The position of this group
           * must overlap this cell. */
          goto skip;
        }
      }

      /* Line was found empty; since the solver tries possible locations
       * left-to-right, any future passes through the loop are also going to
       * find the remainder of the line empty. */
      emptyLine = 1;
    }

    /* This is a potential valid position. */
    state->groupPos[groupIdx] = pos;

    if(groupIdx == clue->len - 1) {

      /* This was the last group, so a valid solution for this line has been
       * found. Mark the cells in the cellState array appropriately. */
      markCells(state, clue, clue->len, line->len);
      valid = 1;
    } else {

      /* Recursively call to place the next group. */
      if(placeGroup(line, clue,
                    groupIdx + 1, pos + clue->a[groupIdx] + 1,
                    state)) {
        valid = 1;
      }
    }

    skip:
  }

  /* Cache the result. */
  state->cache[groupIdx][startPos] = valid + 1;

  return valid;
}

/* Mark the leftmost nCell cells, based on the positions of the first nGroup
 * groups. */
void markCells( SolveState *state, IntArray *clue,
                int nGroup, int nCell )
{
  int x, iGroup;

  for(x = 0, iGroup = 0; iGroup < nGroup; iGroup++) {
    for( ; x < state->groupPos[iGroup]; x++)
      state->cellState[x] |= 2;
    for(int i = 0; i < clue->a[iGroup]; i++, x++)
      state->cellState[x] |= 1;
  }

  for( ; x < nCell; x++)
    state->cellState[x] |= 2;
}

/* Print the current state of the board. */
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
  if(!solveBoard(b)) {
    printf("\n\nNo solution found.\n");
  }

  printBoard(b);
  printf("\n\n");
}
