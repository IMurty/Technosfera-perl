package SecretSanta;

use 5.010;
use strict;
use warnings;
use DDP;


sub calculate {
	my @members = @_;
	my @res;

	my $href = make_list(\@members);
	my %check = %$href;
	#p @members;
	my %hash_of_givers = %check;
	my %hash_of_takers = %check;

	PAIRS:{
			%hash_of_givers = %check;
			%hash_of_takers = %check;
			my @givers = sort keys %hash_of_givers;
			my @takers = sort keys %hash_of_takers;
			my $start_memb = $givers[0];
			my $giver = $givers[0]; #say $memb1;
			my $taker = 0;
			my $last_giver = 0;
			@res = ();
			while (scalar @givers > 0) {
				$taker = $takers[int rand(scalar @takers)];
				if (($taker eq $last_giver)||($taker eq $giver)||($taker eq $check{$giver})) {
					redo PAIRS;
				}

				else {
					push @res, [$giver, $taker];
					delete $hash_of_givers{$giver}; #if exists $hash_of_givers{$memb1};
					delete $hash_of_takers{$taker}; # if exists $hash_of_takers{$memb2};
					@givers = sort keys %hash_of_givers;
					@takers = sort keys %hash_of_takers;
					$last_giver = $giver;
					$taker = $giver;
				}
		}
	}
	return @res;
}
sub make_list {
	my $href = shift;
	my @members = @$href;
	my %check;
	foreach (@members) {
		if(ref $_) {
			$check{@$_[0]} = @$_[1];
			$check{@$_[1]} = @$_[0];
		}
		else {
			$check{$_} = 0;
		}
	}
	#p %check;
	return \%check;
}



my @members = 'A'..'Z';
my %members; @members{@members} = ();
my @pairs;
for (1..@members/4) {
	my ($one,$two) = keys %members;
	delete $members{$one};
	delete $members{$two};
	push @pairs, [ $one, $two ];
}

my @list = sort { int(rand 3)-1 } @pairs, keys %members;
@list = ();
push @list, ["A", "B"];
push @list, ["C", "D"];
push @list, "E";
push @list, "F";
my @res = calculate(@list);
my $i = 0;
for (@res) {
	print "$i ";
	say join "→ ", @$_;
	$i++;
}
