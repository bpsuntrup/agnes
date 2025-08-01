package Tests::App::Agnes::Schema::Result::Account;

use strict;
use warnings;

use Tests::Utils::TestData;

use base 'Tests::Utils::CommonBase';
use Test::More;
use DBI;
use App::Agnes::Config;
use aliased 'App::Agnes::Model';

sub test_attributes : Tests {
    ok(1, "test works");

}

1;
