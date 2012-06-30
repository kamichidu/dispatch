#!/usr/bin/perl

use feature q/:5.10/;
use utf8;
use strict;
use warnings;
use Carp qw/cluck/;
use Getopt::Long;
use constant {
	PREFIX => '~', 
	FORMAT => '', 
	};

sub mv_operate(%);
sub test_operate(%);

MAIN: {
	my ($prefix, $format, $test_mode);

	$prefix= PREFIX;
	$format= FORMAT;
	$test_mode= undef;
	GetOptions(
		'prefix=s' => \$prefix, 
		'format=s' => \$format, 
		'test'     => \$test_mode, 
		);
	Carp::confess 'no input file name format.' unless defined $format;
### $format

	my @files= @ARGV;
	my %file_to;
	my $op= \&mv_operate;
### @files
	
	$op= \&test_operate if $test_mode;

	foreach my $file (@files){
		next unless $file =~ /$format/;
		
		my $to= $file;

		$to=~ s/$format/$1/m;

		$file_to{$file}= "$prefix/$to/$file";
### $file_to{$file}
	}

	$op->(%file_to);
}

sub mv_operate(%){
	my %from_to= @_;

	while(my ($from, $to)= each %from_to){
		rename $from, $to;
	}
}

sub test_operate(%){
	my %from_to= @_;

	while(my ($from, $to)= each %from_to){
		local $,= ' -> ';
		say $from, $to;
	}
}

