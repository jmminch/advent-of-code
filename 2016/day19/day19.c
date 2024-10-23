/* day19.c */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct TreeNode TreeNode;

struct TreeNode {
  int elf;
  int size;
  int isLeft;
  TreeNode *parent;
  TreeNode *left;
  TreeNode *right;
};

TreeNode *buildElfList( int size );
TreeNode *buildTree( int start, int end );
void freeTree( TreeNode *t );
TreeNode *findElfOne( TreeNode *t );
void removeElf( TreeNode *t );
TreeNode *findNextElf( TreeNode *elf, int step );
TreeNode *findIdxInTree( TreeNode *node, int idx );
void steal( TreeNode *elf, int step );

TreeNode *buildElfList( int size )
{
  return buildTree(1, size);
}

TreeNode *buildTree( int start, int end )
{
  TreeNode *t;
  int mid = (start + end) / 2;

  t = malloc(sizeof(TreeNode));
  memset(t, 0, sizeof(TreeNode));

  t->elf = mid;
  t->size = end - start + 1;

  if(mid > start) {
    t->right = buildTree(start, mid - 1);
    t->right->parent = t;
  } else {
    t->right = malloc(sizeof(TreeNode));
    memset(t->right, 0, sizeof(TreeNode));
    t->right->size = 0;
  }

  if(mid < end) {
    t->left = buildTree(mid + 1, end);
    t->left->isLeft = 1;
    t->left->parent = t;
  } else {
    t->left = malloc(sizeof(TreeNode));
    memset(t->left, 0, sizeof(TreeNode));
    t->left->size = 0;
  }

  return t;
}

void freeTree( TreeNode *t )
{
  if(t->right) free(t->right);
  if(t->left) free(t->left);
  free(t);
}

TreeNode *findElfOne( TreeNode *t )
{
  while(t->elf != 1) t = t->right;
  return t;
}

void removeElf( TreeNode *t )
{
  t->elf = 0;
  while(t) {
    t->size--;
    t = t->parent;
  }
}

TreeNode *findNextElf( TreeNode *elf, int step )
{
  return findIdxInTree(elf, step + elf->right->size);
}

TreeNode *findIdxInTree( TreeNode *node, int idx )
{
  if(idx >= node->size) {
    if(node->parent) {
      if(!node->isLeft) {
        return findIdxInTree(node->parent, idx);
      } else {
        return findIdxInTree(node->parent,
                             idx + node->parent->size - node->size);
      }
    } else {
      idx %= node->size;
    }
  }

  if(idx < node->right->size)
    return findIdxInTree(node->right, idx);
  idx -= node->right->size;

  if(node->elf) {
    if(idx == 0) return node;
    idx--;
  }

  return findIdxInTree(node->left, idx);
}

void steal( TreeNode *elf, int step )
{
  elf = findNextElf(elf, step);
  removeElf(elf);
}

int main( int argc, char **argv )
{
  int elves = 3014387;
  TreeNode *tree, *elfPtr;

  if(argc > 1) {
    elves = atoi(argv[1]);
  }

  tree = buildElfList(elves);
  elfPtr = findElfOne(tree);

  while(tree->size > 1) {
    steal(elfPtr, 1);
    elfPtr = findNextElf(elfPtr, 1);
  }
  printf("Part 1 result: %d\n", elfPtr->elf);

  freeTree(tree);

  tree = buildElfList(elves);
  elfPtr = findElfOne(tree);

  while(tree->size > 1) {
    steal(elfPtr, tree->size / 2);
    elfPtr = findNextElf(elfPtr, 1);
  }
  printf("Part 2 result: %d\n", elfPtr->elf);

  freeTree(tree);

  return 0;
}
