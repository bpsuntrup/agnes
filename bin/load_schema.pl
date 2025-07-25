#!/usr/bin/env perl
use strict;
use warnings;

use DBIx::Class::Schema::Loader qw/ make_schema_at /;
use FindBin;
use lib "$FindBin::Bin/../lib";
use App::Agnes::Config;

my $config = App::Agnes::Config->new;

make_schema_at(
    'App::Agnes::Schema',
    { debug => 1,
        dump_directory => "$FindBin::Bin/../lib",
        generate_pod => 0,
        use_namespaces => 1,
        result_base_class => 'App::Agnes::DB::Result',
        resultset_base_class => 'App::Agnes::DB::ResultSet',
        components => ['InflateColumn::DateTime'],
        really_erase_my_files => 1, # BE CAREFUL
    },
    [ $config->{db_conn}->() ]
);

