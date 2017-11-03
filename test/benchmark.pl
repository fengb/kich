#!/usr/bin/env perl

use strict;
use warnings;
use Benchmark qw[timethese cmpthese];

timethese(1000, {
  backticks => sub {
    my $string = `find .`;
    return split /\n/, $string;
  },
  open => sub {
    open(my $pipe, '-|', qw[find .]);
    my @files;
    while(<$pipe>) {
      chomp;
      push @files, $_;
    }
    close $pipe;
    return @files;
  },
  open_line => sub {
    open(my $pipe, '-|', qw[find .]);
    my @files = <$pipe>;
    close($pipe);
    chomp(@files);
    return @files;
  }
})
