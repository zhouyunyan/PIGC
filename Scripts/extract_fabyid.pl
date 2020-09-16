#!/usr/bin/perl -w

use strict;
use Data::Dumper;

unless (@ARGV==3) {
	print "\tUsage: perl extract_fabyid.pl <fasta> <id.list.file> <out.fa>\n\n";
	exit;
}

my ($fa,$list,$out)=@ARGV;
my %id;
open IN,"$list" || die $!;
while (<IN>) {
	chomp;
	s/\s+$//;
	next if (/^$/ || /^\#/);
	my $chr=(split/\s+/,$_)[0];
	$id{$chr}=1;
}
close IN;

open IN,"$fa" || die $!;
open OUT,">$out" || die $!;
$/=">";
while (<IN>) {
	chomp;
	s/\s+$//;
	next if (/^$/ || /^\#/);
	my ($head,$seq)=split/\n+/,$_,2;
	my $chr=(split/\s+/,$head)[0];
	if (exists $id{$chr}) {
		print OUT ">$chr\n$seq\n";
	}
}
$/="\n";
close IN;
close OUT;
