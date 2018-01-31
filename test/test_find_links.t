#!/usr/bin/env perl

use Test::More;

use FindBin;
my $PROJ_DIR = "$FindBin::Bin/..";
require "$PROJ_DIR/bin/kich";

my $TEST_DIR = "$PROJ_DIR/test/files";

is_deeply [find_links($TEST_DIR)], [
  "$TEST_DIR/deep/here",
  "$TEST_DIR/deep/there",
  "$TEST_DIR/here",
  "$TEST_DIR/path.link",
  "$TEST_DIR/there"
];

is_deeply [find_links($TEST_DIR, "here")], [
  "$TEST_DIR/deep/there",
  "$TEST_DIR/path.link",
  "$TEST_DIR/there"
];

is_deeply [find_links($TEST_DIR, "here", "there")], [
  "$TEST_DIR/path.link"
];

done_testing;
