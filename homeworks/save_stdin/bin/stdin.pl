#!/usr/bin/perl

use strict;
use warnings;

use 5.010;
use Getopt::Long qw(GetOptions);
my $filepath = $ARGV[0];
die "USAGE:\n --file <name of file>\n"  unless $filepath;
my $file;
GetOptions('file=s' => \$file) or die "Usage:\n --file <name of file>\n";

$SIG{INT} = sub {
	warn 'Double Ctrl+C for exit';
	$SIG{INT} = 'DEFAULT';
	};

if ($file) {
    say "Get ready";
	open(my $fh, '>', $file) or die $!;
	select ($fh);
	my $counter = 0;
	my $length = 0;
	while (my $str = <STDIN>) {
		print $str;
		$counter++;
		chomp $str;
		$length += length $str;
	};
	close $fh;
	select (STDOUT);
	my $size = -s $file;
	say $length." ".$counter." ".$length/$counter;
};
