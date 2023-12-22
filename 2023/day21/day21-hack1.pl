use Memoize;

memoize("sq");

print sq(101150), "\n";

sub sq {
 return 3911 if $_[0] == 0; 
 return 96435 if $_[0] == 1;
 return 312055 if $_[0] == 2;
 return 650771 if $_[0] == 3;
 return 1112583 if $_[0] == 4;
 return sq($_[0] - 1) + (sq($_[0]-1) - sq($_[0]-2) + 123096);
}
