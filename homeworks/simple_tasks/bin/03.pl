#!/usr/bin/perl

use strict;
use warnings;

=encoding UTF8
=head1 SYNOPSYS

Поиск наименьшего и наибольшего из 3-х чисел

=head1 run ($x, $y, $z)

Функция поиска минимального и максимального из 3-х чисел $x, $y, $z.
Пачатает минимальное и максимальное числа, в виде "$value1, $value2\n"

Примеры: 

run(1, 2, 3) - печатает "1, 3\n".

run(1, 1, 1) - печатает "1, 1\n"

run(1, 2, 2) - печатает "1, 2\n"

=cut

sub run {
    my ($x, $y, $z) = @_;
    my $min = undef;
    my $max = undef;
	{
    	my $max1 = ($x > $y)? $x: $y;
    	my $max2 = ($y > $z)? $y: $z;
    	$max = ($max1 > $max2)? $max1: $max2;
    }
    {
    	my $min1 = ($x < $y)? $x: $y;
    	my $min2 = ($y < $z)? $y: $z;
    	$min = ($min1 < $min2)? $min1: $min2;
    }

    print "$min, $max\n";
}

1;
