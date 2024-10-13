# Nonograms

I've been recently doing some nonograms (from nonograms.org), and got
curious about what it would take to write a solver for them.

For a standard, rectangular, single-color puzzle, the puzzle can be fully
defined by the set of clues for each row/column. At first I defined my own
format. Each row of the input defines a set of clues for a row or column (a
space-separated list of numbers.) First are the column clues, from left to
right; followed by a blank line; and then the row clues from top to bottom.

One problem - it's kind of a pain to try to manually enter all the clues
for even a moderately-sized puzzle. The website https://webpbn.com has a
bunch of puzzles and an export function at <https://webpbn.com/export.cgi>.
The "native" format for that website is an XML-based format that I don't
want to deal with, but it is able to export puzzles in a large variety of
formats.

After looking at a few, I settled on the .CWD format, which is fairly
similar to what I initially had designed. The format is line-based, as
follows:

| Line  | contents |
| ---   | --- |
| 1     | puzzle height |
| 2     | puzzle width |
| 3-n   | row clues, 1 per row |
| n+1   | blank |
| n+2-m | column clues, 1 per column |

For the most part, nonograms can be solved working line-by-line (whether the
lines are horizontal or vertical.) The general approach that I am taking is
to take any already-known information about a line (from earlier analysis of
the puzzle), and then determine all possible layouts of cells for the line.
After determining all combinations, any cells that can only be marked or
only unmarked can be add to the known information for the lines.

My first idea is to work cell-by-cell to find the combinations. I can start
from the beginning of the line, working toward the end. For the first
unknown cell, determine if it may be marked and/or unmarked recursively:

1. Set the cell to marked.
2. Check whether the line up to this cell potentially matches the clues. If
   it doesn't, then this cell cannot be marked.
3. If this is the last cell, then this is a potential solution. Record that
   this cell may be marked.
4. If this cell is not the last cell, then recursively call to check the
   next cell. If that results in determining that there is a valid solution,
   then record that this call may be marked.
5. Repeat steps 1-4 with the cell unmarked.
6. If the cell may be marked or unmarked, return to the caller that there
   exists a valid solution.
7. Otherwise, return to the caller that there is no valid solution.

I implemented this approach, which works, although it is pretty slow for
large puzzles. After thinking about it some more, I decided that a different
approach might perform better. Instead of working cell-by-cell, I can work
through the list of clues (which are groups of cells), and try all
possibilities for the placement of those groups. Since there's a relatively
small number of groups, that means fewer total possibilities.

Implementing this approach is much faster.

Trying a few more, I found a puzzle linked at
<https://www.reddit.com/r/nonograms/comments/a6y2pd/the_hardest_one_ive_ever_attempted_help_please/>
which has the interesting property that it can't be solved working simply
line-by-line. To solve puzzles like this, the easiest method is probably
solve as much as possible, and then guess one of the unknown cells;
repeating until either a solution is found or there is a contradiction.

I spent a lot of time debugging this part of the solution; it turned out
that I made a couple mistakes transcribing the puzzle.

`web020910.cwd` is an example of a puzzle that takes a very long time to
solve. While it makes progress on each pass, it doesn't add a whole lot of
information each time, and checking the combinations over and over take a
lot of time. I have a couple ideas for improving things:

1. The solveLine function may continue trying possibilities even after it's
   found enough information to know that it won't be able to eliminate any
   possible cell states.
2. If there's been no changes to the line since the last time it was
   analyzed, then there's no point in redoing the analysis. This could be
   addressed by keeping track of what the state of the line was the last
   time it was analyzed.
3. After finding any new information, I could prioritize looking at the
   perpendicular line.

I implemented #2 first, which improved the solution time for that puzzle
significantly -- down to 1m14s from 10m30s. It doesn't really have any
impact on the other puzzles I've been testing with.

Implementing #3 actually made things much slower. That surprises me, and I
wonder if there's something wrong with my implementation.

I tried a different hueristic for guessing cells; trying the guess the cell
that was in the row/column with the least unknown information (on the idea
that doing so would make that row and column easier to solve.) That didn't
work out, though; it took significantly longer to solve the puzzle that way.

I thought of a mechanism to speed up solving an individual line with a lot
of possibilities. Trying to place group N at the same location will always
have the same result, and so I don't need to keep repeating it. So I can add
some logic to placeGroup that stores the result (valid/invalid) for a
particular group being placed at a particular location. If there is a result
stored, then I do need to still appropriately mark the cells for the earlier
groups since they will be at different locations than have been tried
before.

That turns out to be a massive improvement. The puzzle that previously took
over a minute to complete now only takes 41 milliseconds.

I did find another puzzle which gives my solver difficulty:
`webpbn002195.cwd`. It takes over 8 seconds, due to making a large number of
guesses (guessing 4683 times.)

A potential solution to making guessing more efficient is to guess the
locations of an entire group rather than just a single cell. To do that, I
will:

1. Search for the first unknown cell in a row
2. Determine the first unknown group in the row
3. The first location it could be placed would be the unknown cell;
   determine the last location it could be placed.
4. Starting from that first cell, try placing the group at each location
   until one that leads to a solution is found.

Tried this, and it is a little bit faster for the problem puzzle, but not by
much (solution time down to 7.5 seconds.)

I've got one other idea before I call it on this: it might help if, rather
than looking at the first row with any unknown cells, instead I check all
the lines and make my guess on the one with the smallest number of
possibilities.

The last thing I did was update nonogram.c with a bunch of general code
cleanup, improved comments, etc.
