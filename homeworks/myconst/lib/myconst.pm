package myconst;

use strict;
use warnings;
use Scalar::Util 'looks_like_number';


=encoding utf8

=head1 NAME

myconst - pragma to create exportable and groupped constants

=head1 VERSION

Version 1.00

=cut

our $VERSION = '1.00';

=head1 SYNOPSIS
package aaa;

use myconst math => {
        PI => 3.14,
        E => 2.7,
    },
    ZERO => 0,
    EMPTY_STRING => '';

package bbb;

use aaa qw/:math PI ZERO/;

print ZERO;             # 0
print PI;               # 3.14
=cut

our %CONSTANTS;
our %GROUPS;

sub import {
    my ( $self, @str ) = @_;
	die "have not args\n" if @str == 1;
	foreach (@str) {
		die "INVALID ARGS!" if (!defined $_) ;
	}
	my %hash = @str;
	my $caller = caller(0);
	&parse_hash (\%hash);
	no strict 'refs';
    for my $key ( keys %CONSTANTS ) {
        *{"$caller::$key"} = sub() { $CONSTANTS{$key}; };
    };
};

sub parse_hash {
    my $hash = shift;
	my $group_name = shift;
    while (my ($key, $value) = each %$hash) {
		die if (ref $value eq 'ARRAY');
        if ('HASH' eq ref $value) {
			die "INVALID ARGS!" unless (%$value);
            &parse_hash ($value, $key);
        }
        elsif ((defined $key) && (defined $value)) {
            push @{$GROUPS{all}}, $key;
			push @{$GROUPS{$group_name}}, $key if ($group_name);
			$CONSTANTS{$key} = $value;
        }
		else {
			die "INVALID ARGS!";
		}
    }
};


1;
