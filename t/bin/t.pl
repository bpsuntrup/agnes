#!/usr/bin/env perl

use strict;
use warnings;

use FindBin qw($Dir);
BEGIN {
    print "$Dir/../lib\n";
}
use lib "$Dir/../lib";
use lib "$Dir/../../lib";

use Test::Class;

my $class = shift;
my $method = shift;

(my $file = "$class.pm") =~ s/::/\//g;
require $file;


if ($method) {
    $ENV{TEST_METHOD} = $method;
}

Test::Class->runtests;

