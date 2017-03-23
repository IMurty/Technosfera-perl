#!/usr/bin/perl

use strict;
use warnings;
our $VERSION = 1.0;
my $filepath = $ARGV[0];
die "USAGE:\n$0 <log-file.bz2>\n"  unless $filepath;
die "File '$filepath' not found\n" unless -f $filepath;

my @parsed_data = parse_file($filepath);
report(@parsed_data);
exit;

sub parse_file {
    my $file = shift;
    my %result;
    my $ip_ptrn = '(?<ip>\d+\.\d+\.\d+\.\d+)';
    my $date_ptrn = '\[(?<day>\d{2})\/(?<mounth>\w{3})\/(?<year>\d{4}):(?<hours>\d{2}):(?<minutes>\d{2}):(?<seconds>\d{2}) (?<timezone>\+\d{4})\]';
    my $status_ptrn = '(?<status>\d{3})';
    my $bytes_ptrn = '(?<bytes>\d+)';
	my $refferer_ptrn     = '"(?<reffr>[^"]+?)"';
   	my $user_agent_ptrn   = '"(?<user>[^"]+?)"';
    my $coefficient_ptrn  = '"(?<coefficient>[^"]+?)"';

    open my $fd, "-|", "bunzip2 < $file" or die "Can't open '$file': $!";
	my $zip_coeff;
	my $status;
	my $data;

	while (my $log_line = <$fd>) {
		$log_line =~ /^$ip_ptrn\s+$date_ptrn\s+$refferer_ptrn\s+$status_ptrn\s+$bytes_ptrn\s+$refferer_ptrn\s+$user_agent_ptrn\s+$coefficient_ptrn$/;
		if ($+{ip} && $+{status} && $+{coefficient}) {

	        $result{$+{ip}}->{count} += 1;
	        $result{total}->{count} += 1;

			$result{total}{minutes}{$+{day}.$+{mounth}.$+{year}.$+{hours}.$+{minutes}} = 1;
			$result{$+{ip}}->{minutes}->{$+{day}.$+{mounth}.$+{year}.$+{hours}.$+{minutes}} = 1;

	        $status = $+{status}+0;
	        $data = $+{bytes}+0;
	        $result{$+{ip}}->{status}->{$status} += $data;
	        $result{total}->{status}->{$status} += $data;

	        $zip_coeff = $+{coefficient} eq "-" ? 1 : $+{coefficient}+0;

			if ( $status == 200 ) {
				$result{$+{ip}}->{data} += int( $zip_coeff * $data );
				$result{total}->{data} += int( $zip_coeff * $data );
			}
		}
    }
    close $fd;
	my @sorted_ip_list = sort {$result{$b}->{count} <=> $result{$a}->{count}} keys %result;
	foreach (@sorted_ip_list[11..$#sorted_ip_list]) {
		delete $result{$_};
	}
    for my $ip ( keys %result ) {
        $result{$ip}->{average} = $result{$ip}->{count}/(scalar keys %{$result{$ip}->{minutes}});
		delete $result{$ip}->{minutes};
    }
	@sorted_ip_list = @sorted_ip_list[0..10];
	return (\%result, \@sorted_ip_list);
}

sub report {
	my $result = shift;
	my $list = shift;
	my @statuses = sort {$a <=> $b} keys %{$result->{total}->{status}};
	my $row_format = "%s\t%d\t%.2f\t%d".("\t%d" x @statuses)."\n";
	my $header_format = "IP	count	avg	data".("\t%d" x @statuses)."\n";
	my $statuses_str = join "\t",@statuses;
	printf $header_format, @statuses;
	foreach my $ip (@$list) {
		my @str;
		foreach (@statuses) {
			my $push = exists ($result->{$ip}->{status}->{$_}) ? $result->{$ip}->{status}->{$_}/1024: 0;
			push @str, $push;
		}
		printf $row_format, $ip, $result->{$ip}->{count}, $result->{$ip}->{average}, $result->{$ip}->{data}/1024, @str;
	}
}
