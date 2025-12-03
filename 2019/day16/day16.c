#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <ctype.h>

int8_t digits[1024];
int inputLen = 0;
int totalLen;

int8_t *cache[200] = { 0 };

int digitAt( int d )
{
  return digits[d % inputLen];
}

int getCache( int step, int digit )
{
  if(step == 0) return digitAt(digit);
  if(!cache[step]) return -1;
  if(cache[step][digit] == 0) return -1;
  return cache[step][digit] - 1;
}

void setCache( int step, int digit, int value )
{
  if(!cache[step]) {
    cache[step] = malloc(totalLen);
    memset(cache[step], 0, totalLen);
  }

  cache[step][digit] = value + 1;
}

void fft2Calc( int step, int firstDigit )
{
  int total = 0;

  if(step == 0) return;
  if(getCache(step - 1, firstDigit) == -1) fft2Calc(step - 1, firstDigit);

  /* work backwards starting at the last digit. */
  for(int i = totalLen - 1; i >= firstDigit; i--) {
    if(i == totalLen - 1) {
      total = digitAt(i);
      setCache(step, i, total);
    } else {
      total += getCache(step - 1, i);
      if(total > 9) total -= 10;
      setCache(step, i, total);
    }
  }

  return;
}

int main( int argc, char **argv )
{
  char buf[1025];
  char *bp;
  int offset, i;

  fgets(buf, 1024, stdin);
  buf[1024] = '\0';
  for(bp = buf; isdigit(*bp); bp++, inputLen++) {
    digits[inputLen] = *bp - '0';
  }

  totalLen = inputLen * 10000;

  for(offset = 0, i = 0; i < 7; i++) {
    offset *= 10;
    offset += digits[i];
  }

  fft2Calc(100, offset);

  printf("Part 2 result: ");
  for(i = offset; i < offset + 8; i++) {
    printf("%d", getCache(100, i));
  }
  printf("\n");
  return 0;
}
