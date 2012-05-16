#!/usr/bin/perl

use strict;

sub retry_ssh{
	my $cmd = shift @_;

	my $out = "";
	my $count = 0;
	while( $out == "" && $count < 3 ){
		print "[SSH:$count]\tExecuting Command: $cmd\n";

		$out = `$cmd`;
		chomp($out);
		print "[SSH:$count]\tOutput: $out\n";
		if( $out ne "" ){
			return $out . "\n";
		};
		$count++;
		sleep 1;
	}
	return "";
};

1;

