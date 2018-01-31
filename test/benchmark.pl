#!/usr/bin/env perl

use strict;
use warnings;
use Benchmark qw[timethese];

sub feval {
  my $cmd = shift;
  if (fork) {
    wait;
  } else {
    eval $cmd;
    exit 0;
  }
}

my %benches = (
  use => sub {
    timethese(1000, {
      system           => sub { feval 'system "test"' },
      'File::Basename' => sub { feval 'use File::Basename qw[dirname];' },
      'File::Copy'     => sub { feval 'use File::Copy qw[move];' },
      'File::Path'     => sub { feval 'use File::Path qw[make_path];' },
      'File::Spec'     => sub { feval 'use File::Spec;' },
      'File::Find'     => sub { feval 'use File::Find;' },
      'GetOpt::Long'   => sub { feval 'use Getopt::Long;' },
      'GetOpt::Short'  => sub { feval 'use Getopt::Std qw[getopts];' }
    });
  },

  exec => sub {
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
    });
  }
);

unless (caller) {
  if (defined $ARGV[0]) {
    $benches{$ARGV[0]}->();
  } else {
    print "Benchmarks:\n";
    foreach my $name(keys %benches) {
      print "\t$name\n";
    }
  }
}
