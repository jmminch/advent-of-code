$/ = "\n\n";
@records = <>;

for my $rec (@records) {
  # parse the record into fields.
  my @fieldList = split /\s+/, $rec;
  my %fields = ( );
  for $field (@fieldList) {
    my ($name, $value) = split /:/, $field;
    $fields{$name} = $value;
  }

  # check whether the record has all required fields.
  my @reqField = qw(byr iyr eyr hgt hcl ecl pid);
  my $valid = 1;
  for my $field (@reqField) {
    if(!exists $fields{$field}) {
      $valid = 0;
      last;
    }
  }
  next if !$valid;
  $part1++;

  # validate all fields for part 2
  $valid2 = 1;
  if($fields{byr} =~ /^(\d{4})$/) {
    $valid2 = 0 if $fields{byr} < 1920 || $fields{byr} > 2002;
  } else {
    $valid2 = 0;
  }
  if($fields{iyr} =~ /^(\d{4})$/) {
    $valid2 = 0 if $fields{iyr} < 2010 || $fields{iyr} > 2020;
  } else {
    $valid2 = 0;
  }
  if($fields{eyr} =~ /^(\d{4})$/) {
    $valid2 = 0 if $fields{eyr} < 2020 || $fields{eyr} > 2030;
  } else {
    $valid2 = 0;
  }
  if($fields{hgt} =~ /^(\d+)(cm|in)$/) {
    $valid2 = 0 if $2 eq 'cm' and ($1 < 150 || $1 > 193);
    $valid2 = 0 if $2 eq 'in' and ($1 < 59 || $1 > 76);
  } else {
    $valid2 = 0;
  }
  $valid2 = 0 if !($fields{hcl} =~ /^#[0-9a-f]{6}$/);
  $valid2 = 0 if !($fields{ecl} =~ /^(amb|blu|brn|gry|grn|hzl|oth)$/);
  $valid2 = 0 if !($fields{pid} =~ /^\d{9}$/);
  $part2++ if $valid2;
}

print "part 1 result: $part1\n";
print "part 2 result: $part2\n";
