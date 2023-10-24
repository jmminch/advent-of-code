# Word search generation

I was thinking about word-search puzzles (a grid of letters which contains a
set of hidden words, which can run in any direction in the grid.) An
interesting puzzle, given a list of words, is what is the minimum-sized grid
required to create a word-search puzzle containing every word.

I'm not sure what the most interesting metric to use would be. Trivially, if
the total number of letters in the list is N, then a 1xN grid would suffice,
and in many cases would probably be the smallest possible area. A metric
like `width + height` might be more interesting in terms of requiring more
complicated arrangements of words.

To start, I'll create a function to answer the question of whether there
exists an arrangement of the list of words in a grid of a particular size.

The word list will have one word per line. All letters will be converted to
upper-case, and any non-letter characters will be removed. (So a two-word
line will remove the space, etc.)

A very simple algorithm to determine if there is a valid arrangement is to
start with the first word, and try to place it in each place in each
direction. If it fits, then try the next word, etc. If a word doesn't fit
anywhere, then back up to the previous word to try a different
location/direction. This can be easily implemented recursively.

My first attempt (about as simple as possible) does the following:

- The grid is represented as a hash, indexed by coordinates (a string of the
  form "x.y"). This isn't very efficient, but it's very simple to implement.
- The elements of the hash, when present, are a list. The first element is
  the character at that position. The second element is the number of times
  a character has been added to that position. The count is required so that
  when I'm backing up, I know whether to clear out the character or not.
- Try placing each word starting at (0,0) in every direction, then move to
  another space, until all possibilities are exhausted, at which point we
  back up to do it again.

I implemented it this way, and found that it was taking a very long time.
Sorting the input list in order of descending length helped, but not enough.

First optimization: try to use a more efficient data structure for the grid.
I'll use two arrays of size (width * height); the first will contain the
character at (x,y) and the second will contain the count. Since I
implemented a getter and setter for getting grid elements from the
beginning, changing the structure is pretty easy. Turns out that this
doesn't really have a very significant impact (about 7% improvement).

A couple of observations that might make things quicker:

- If there is a solution, then it can be rotated/reflected in any way. I can
  cut a bunch of possibilities by limiting the placement directions of the
  first word. In the case of a square grid, placing it in one orthogonal
  direction and one diagonal direction (so left-to-right, and top-left to
  bottom-right) would be sufficient. For a non-square grid, the
  top-to-bottom direction would be required too.
- I spend a lot of time trying to place words in a direction that goes off
  the edge of the board. Optimizing that would probably help.
