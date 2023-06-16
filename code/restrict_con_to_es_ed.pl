#!/usr/bin/env perl
use strict;
use warnings;

open IN, "<$ARGV[0]" or die $!;
my $write = 1;
my $xy_header = 0;
my $es = -1;
my $ed = -1;
while(<IN>){
	if(/manual_lv_es_phase=(\d+)/){
		$es = $1;
	}
	if(/manual_lv_ed_phase=(\d+)/){
		$ed = $1;
	}
	if(/\[/){
		$write = 1;
	}
	if($xy_header){
		/^\d+ (\d+) \d+/;
		if($1 eq $es || $1 eq $ed){
			print("[XYCONTOUR]\n");
			$write = 1;
		}
		$xy_header = 0;
	}
	if(/XYCONTOUR/){
		$write = 0;
		$xy_header = 1;
	}
	if($write){
		print $_;
	}
}
close IN or die $!;
