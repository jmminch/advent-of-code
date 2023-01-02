#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

int numWeights = 0; // Number of entries in the weights array
int weights[100];  // Input data
int used[100] = { 0 };  // Temporary storage for which group each weight is in
int minGroup = 999999;  // minimum valid group size found
uint64_t minProduct = UINT64_MAX;  // Minimum product found so far (result)
int thirdWeight = 0;  // one-third of the total of the weights (part 1)
int qWeight = 0;  // one-quarter of the total of the weights (part 2)

void handleGroup2( void );
void pt2_2( void );
void pt2_3( void );

/* Find all groups of unused weights, with a total weight of maxWeight,
 * starting at array index startIdx. When one is found, run the provided
 * callback. */
void makeCombo( int group, int maxWeight, int startIdx, void (*cb)(void) )
{
  for(int idx = startIdx; idx < numWeights; idx++) {
    if(used[idx] != 0) continue;  // skip over weights already used

    /* Add this weight to the current group */
    used[idx] = group;
    maxWeight -= weights[idx];
    if(maxWeight > 0) {
      /* Not enough weights in the group yet, keep going. */
      makeCombo(group, maxWeight, idx + 1, cb);
    } else if (maxWeight == 0) {
      /* Found a valid combination. */
      cb();
    }
    /* Otherwise, this combination has too high a total weight, just skip
     * it. */

    /* Remove this weight from the group */
    maxWeight += weights[idx];
    used[idx] = 0;
  }
}

/* Callback after the first group is found for part 1 */
void handleGroup1( void )
{
  int gSize = 0;
  for(int i = 0; i < numWeights; i++) {
    if(used[i] == 1) gSize++;
  }
  if(gSize > minGroup) return;

  makeCombo(2, thirdWeight, 0, handleGroup2);
}

/* Callback after the second group is found for part 1 */
void handleGroup2( void )
{
  int gSize[3] = { 0 };
  uint64_t product = 1;

  /* Find group sizes and the product for group 1 */
  for(int i = 0; i < numWeights; i++) {
    gSize[used[i]]++;
    if(used[i] == 1) {
      product *= weights[i];
    }
  }

  /* Set the minimum valid group size if any of the groups found are smaller
   * than the current minimum. */
  if(minGroup > gSize[0]) {
    minGroup = gSize[0];
    minProduct = UINT64_MAX;
  }
  if(minGroup > gSize[1]) {
    minGroup = gSize[1];
    minProduct = UINT64_MAX;
  }
  if(minGroup > gSize[2]) {
    minGroup = gSize[2];
    minProduct = UINT64_MAX;
  }

  /* Only consider groups that are the minimum group size. */
  if(gSize[1] > minGroup) return;

  if(minProduct > product) {
    minProduct = product;
  }
}

/* Following functions are the same as above, just copy-pasted and with some
 * minor alterations needed for part 2. */
/* Callback after the first group is found for part 2 */
void pt2_1( void )
{
  int gSize = 0;
  for(int i = 0; i < numWeights; i++) {
    if(used[i] == 1) gSize++;
  }
  if(gSize > minGroup) return;

  makeCombo(2, qWeight, 0, pt2_2);
}

/* Callback after the second group is found for part 2 */
void pt2_2( void )
{
  makeCombo(3, qWeight, 0, pt2_3);
}

/* Callback after the third group is found for part 2 */
void pt2_3( void )
{
  int gSize[4] = { 0 };
  uint64_t product = 1;

  for(int i = 0; i < numWeights; i++) {
    gSize[used[i]]++;
    if(used[i] == 1) {
      product *= weights[i];
    }
  }

  if(minGroup > gSize[0]) {
    minGroup = gSize[0];
    minProduct = UINT64_MAX;
  }
  if(minGroup > gSize[1]) {
    minGroup = gSize[1];
    minProduct = UINT64_MAX;
  }
  if(minGroup > gSize[2]) {
    minGroup = gSize[2];
    minProduct = UINT64_MAX;
  }
  if(minGroup > gSize[3]) {
    minGroup = gSize[3];
    minProduct = UINT64_MAX;
  }

  if(gSize[1] > minGroup) return;

  if(minProduct > product) {
    minProduct = product;
  }
}

int main( int argc, char **argv )
{
  /* Read the input data */
  char buf[100];
  int totalWeight = 0;
  while(fgets(buf, 99, stdin)) {
    weights[numWeights++] = atoi(buf);
    totalWeight += weights[numWeights - 1];
  }

  /* Calculate the target weights for both parts. */
  thirdWeight = totalWeight / 3;
  qWeight = totalWeight / 4;

  makeCombo(1, thirdWeight, 0, handleGroup1);
  printf("part 1 result: %lld\n", minProduct);
  minProduct = UINT64_MAX;
  minGroup = 999999;
  makeCombo(1, qWeight, 0, pt2_1);
  printf("part 2 result: %lld\n", minProduct);
}
