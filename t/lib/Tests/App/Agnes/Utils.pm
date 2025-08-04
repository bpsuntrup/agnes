package Tests::App::Agnes::Utils;

use strict;
use warnings;

use base 'Test::Class';
use Test::More;
use App::Agnes::Utils qw/is_valid_uuid/;

sub test_valid_uuid : Tests {
    ok(is_valid_uuid('bcfcada6-31de-463c-a02d-b2a5673cea9f'), "valid uuid accepted");
    ok(!is_valid_uuid('bcfada6-31de-463c-a02d-b2a5673cea9f'), "irregular uuid rejected");
}

1;
