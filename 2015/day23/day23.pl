my @inst = <>;
chomp @inst;

sub run {
  my @inst = @{$_[0]};
  my %regs = ( a=>$_[1], b=>0 );
  my $ip = 0;

  while($ip >= 0 && $ip <= $#inst) {
    if(!($inst[$ip] =~ /^(...) ([ab\-+0-9]+)(, ([+\-0-9]+))?/)) {
      die "bad instruction $ip";
    }

    my ($op, $arg1, $arg2) = ($1, $2, $4);

    if($op eq 'hlf') {
      $regs{$arg1} = int($regs{$arg1} / 2);
      $ip++;
    } elsif($op eq 'tpl') {
      $regs{$arg1} *= 3;
      $ip++;
    } elsif($op eq 'inc') {
      $regs{$arg1}++;
      $ip++;
    } elsif($op eq 'jmp') {
      $ip += int($arg1);
    } elsif($op eq 'jie') {
      if(($regs{$arg1} % 2) == 0) {
        $ip += int($arg2);
      } else {
        $ip++;
      }
    } elsif($op eq 'jio') {
      if($regs{$arg1} == 1) {
        $ip += int($arg2);
      } else {
        $ip++;
      }
    }
  }

  return $regs{b};
}

printf "part 1 result: %d\n", run(\@inst, 0);
printf "part 2 result: %d\n", run(\@inst, 1);
