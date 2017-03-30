#!/usr/bin/perl

use strict;
use warnings;
use Getopt::Long qw(GetOptions);
my $filepath = $ARGV[0];
die "USAGE:\n --file <name of file>\n"  unless $filepath;
my $file;
GetOptions('file=s' => \$file) or die "Usage:\n --file <name of file>\n";
my $double_tap = 0;
my $counter = 0;
my $length = 0;
my $avg = 0;
$SIG{INT} = sub {
	if ($double_tap == 1) {
		eval {$avg = $length/$counter};

		print STDOUT "$length $counter $avg\n";
		exit;
	}
	else {
		print STDERR "Double Ctrl+C for exit";
		$double_tap = 1;
	}
};
if ($file) {
    print STDOUT "Get ready\n";
	open(my $fh, '>', $file) or die $!;
	while (my $str = <STDIN>) {
		print $fh $str;
		$counter++;
		chomp $str;
		$length += length $str;
	};
	close $fh;
	$SIG{'INT'} = 'DEFAULT';
	eval {$avg = $length/$counter};
	print STDOUT "$length $counter $avg";
};
