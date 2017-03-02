package SecretSanta;
use 5.010;
use strict;
use warnings;
use DDP;

sub calculate {
	my @members = @_;
	my @res;
	my $href = make_list(\@members);
	my %pairs = %$href;
	my %hash_of_givers = %pairs;
	my %hash_of_takers = %pairs;
PAIRS:{
	%hash_of_givers = %pairs;
	%hash_of_takers = %pairs;
	my @givers = sort keys %hash_of_givers;
	my @takers = sort keys %hash_of_takers;
	my $start_memb = $givers[0];
	my $giver = $givers[0];
	my $taker = 0;
	my $last_giver = 0;
	@res = ();
	while (scalar keys %hash_of_givers > 0) {
			$taker = $takers[int rand(scalar @takers)];
			if (($taker ne $last_giver) && ($taker ne $pairs{$giver}) && ($taker ne $giver)) {
				push @res, [$giver, $taker];
				delete $hash_of_givers{$giver};
				delete $hash_of_takers{$taker};
				@givers = sort keys %hash_of_givers;
				@takers = sort keys %hash_of_takers;
				if ($taker eq $start_memb) {
					$giver = $givers[int rand(scalar @givers)];
					$start_memb = $giver;
					$last_giver = 0;
				}
				else {
					$last_giver = $giver;
					$giver = $taker;
				}
			}
			else {
				redo PAIRS;
			}
		}
	}
	return @res;
}

sub make_list {
	my $href = shift;
	my @members = @$href;
	my %pairs;
	foreach (@members) {
		if(ref $_) {
			$pairs{@$_[0]} = @$_[1];
			$pairs{@$_[1]} = @$_[0];
		}
		else {
			$pairs{$_} = 0;
		}
	}
	return \%pairs;
}
1;
