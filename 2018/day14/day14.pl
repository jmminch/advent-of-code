use strict vars;

our $input = shift // 540561;
our $firstDigit = substr($input, 0, 1);

our @board = (3, 7);
our $elf1 = 0;  # elf 1 pointer
our $elf2 = 1;  # elf 2 pointer
our $part1 = -1;
our $part2 = -1;

while($part1 < 0 || $part2 < 0) {
  my $newRecipe = $board[$elf1] + $board[$elf2];
  # Add the 10s digit if required (has to be 1 or 0) and then add the ones
  # digit.
  if($newRecipe > 9) {
    addRecipe(1);
    $newRecipe -= 10;
  }
  addRecipe($newRecipe);
  
  # move elf pointers
  $elf1 = ($elf1 + 1 + $board[$elf1]) % scalar(@board);
  $elf2 = ($elf2 + 1 + $board[$elf2]) % scalar(@board);
}

print "Part 1 result: $part1\n";
print "Part 2 result: $part2\n";

sub addRecipe {
  push @board, $_[0];

  # part 1 -- scores of the ten recipes right after the input number
  if(scalar @board == $input + 10) {
    $part1 = join '', @board[-10 .. -1];
  }

  # part 2 -- location of the input sequence on the board
  if($part2 < 0) {
    # figure out if the sequence ends with the digits from input
    my $len = length $input;
    # The first digit check is just to quickly eliminate possibilities
    # before doing the relatively slow process of joining the last few
    # digits of @board.
    if($board[-$len] == $firstDigit &&
       $input eq join('', @board[-$len .. -1])) {
      # Result is the current length of sequence, minus the length of the
      # input.
      $part2 = scalar @board - $len;
    }
  }
}
