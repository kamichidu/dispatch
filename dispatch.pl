#!/usr/bin/perl

use feature q/:5.10/;
use utf8;
use strict;
use warnings;
use Carp qw/cluck/;
use Getopt::Long;
use Pod::Usage;
use constant {
	PREFIX => '~', 
	FORMAT => '', 
	};

sub mv_operate(%);
sub test_operate(%);

MAIN: {
	my ($prefix, $format, $test_mode, $help, $man);

	$prefix= PREFIX;
	$format= FORMAT;
	$test_mode= 0;
	$help= 0;
	$man= 0;
	GetOptions(
		'prefix=s' => \$prefix, 
		'format=s' => \$format, 
		'test'     => \$test_mode, 
		'help|?'   => \$help, 
		'man'      => \$man, 
		) or pod2usage(2);
	pod2usage(1) if $help;
	pod2usage(-exitstatus => 0, -verbose => 2) if $man;
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

__END__

=encoding utf-8

=head1 NAME

dispatch - 正規表現によってファイル名から対応するディレクトリに、引数として渡された(複数の)ファイルを移動する。

=head1 SYNOPSIS

dispatch [options] [file ...]

=head1 OPTIONS

=over 8

=item B<--format>

=item B<--prefix>

=item B<--test>

=item B<--help>

簡単なドキュメントを表示する。

=item B<--man>

ドキュメントを表示する。

=back

=head1 DESCRIPTION



=cut

