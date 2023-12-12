#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

typedef struct {
  int first;
  int last;
  int cur;
  int loc;
} StateElem;

int64_t countPoss( char *str, int *groups, int nGroup )
{
  StateElem state[128] = { 0 };
  int sp = 0;
  int64_t count = 0;
  int len = strlen(str);
  int loc;
  int i;

  state[0].cur = -1;
  state[0].loc = 0;
  while(sp >= 0) {

    if(sp == nGroup) {
      for(i = state[sp].loc; i < len; i++) {
        if(str[i] == '#') break;
      }
      if(i >= len) count++;
      sp--;
      continue;
    }

    if(state[sp].cur == -1) {
      int nextQ, nextH;
      int first, last;
      for(nextQ = state[sp].loc; nextQ < len; nextQ++) {
        if(str[nextQ] == '?') break;
      }
      for(nextH = state[sp].loc; nextH < len; nextH++) {
        if(str[nextH] == '#') break;
      }
      first = (nextQ < nextH) ? nextQ : nextH;
      last = len - groups[sp];
      if(nextH < last) last = nextH;

      if(first >= len || first > last) { sp--; continue; }

      state[sp].first = first;
      state[sp].last = last;
    }

    state[sp].cur++;
    
    loc = state[sp].first + state[sp].cur;
    if(loc > state[sp].last) { sp--; continue; }

    for(i = 0; i < groups[sp]; i++) {
      if(str[loc + i] == '.') break;
    }
    if(i < groups[sp]) continue;

    if(loc + groups[sp] < len && str[loc + groups[sp]] == '#') {
      continue;
    }

    state[sp + 1].cur = -1;
    state[sp + 1].loc = loc + groups[sp] + 1;
    sp++;
  }

  return count;
}

int main( int argc, char **argv )
{
  int64_t count = 0;
  int64_t count2 = 0;
  char buf[4096];
  char buf2[4096];

  while(fgets(buf, 4096, stdin)) {
    char *spc = index(buf, ' ');
    char *str;
    int groups[1024];
    int nGroup;
    char *val;
    if(!spc) continue;
    *spc = '\0';
    str = buf;
    for(nGroup = 0, val = strtok(spc + 1, ","); val;
      val = strtok(NULL, ","), nGroup++) {
      groups[nGroup] = atoi(val);
    }

    count += countPoss(str, groups, nGroup);

    strcpy(buf2, str);
    for(int i = 0; i < 4; i++) {
      strcat(buf2, "?");
      strcat(buf2, str);
    }

    for(int i = 1; i < 5; i++) {
      for(int j = 0; j < nGroup; j++) {
        groups[i * nGroup + j] = groups[j];
      }
    }

    count2 += countPoss(buf2, groups, nGroup * 5);

    printf("%lld\n", count2);
  }
  printf("Part 1 result: %lld\n", count);
  printf("Part 2 result: %lld\n", count2);
  return 0;
}
