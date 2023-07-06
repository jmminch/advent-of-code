my $input = <>;
chomp $input;

printf "Part 1 result: %d\n", decode($input, 1);
printf "Part 2 result: %d\n", decode($input, 2);

sub decode {
  my $size = 0;

  for(my $sp = 0; $sp < length $_[0]; $sp++) {
    my $c = substr($_[0], $sp, 1);
    if($c eq '(') {
      my $tmp = substr($_[0], $sp);
      if($tmp =~ /^\((\d+)x(\d+)\)/) {
        my $markLen = length $&;
        my $strLen = $1;
        my $repeat = $2;
        $sp += $markLen;
        if($_[1] == 1) {
          $size += $repeat * $strLen;
        } else {
          $size += $repeat * decode(substr($_[0], $sp, $strLen));
        }
        $sp += $strLen;
        $sp--; # since sp will get incremented at the end of the loop.
      } else {
        die "parse error!\n"
      }
    } else {
      $size++;
    }
  }
  return $size;
}
