package Tests::Utils::CommonBase;

use strict;
use warnings;

use Tests::Utils::TestData;

use base qw(Test::Class);
use DBI;
use App::Agnes::Config;
use aliased 'App::Agnes::Model';

sub set_up_db : Test(startup) {
    # Create database:
    my $dbh = DBI->connect("dbi:Pg:dbname=postgres"); # TODO: set up test_runneraccount 
    $dbh->do("CREATE DATABASE agnes_test");
    $dbh->disconnect;

    # Load in schema:
    my $src_db = 'agnes'; # TODO: copy from dev env
    my $dest_db = 'agnes_test'; # TODO: make multiple names possible to run ast
    my $schema_dump = `pg_dump --schema-only $src_db`;
    die "pg_dump failed" unless $schema_dump;
    open my $psql, "|-", "psql -q $dest_db" or die "psql failed :$!";
    print $psql $schema_dump;
    close $psql or die "Error loading schema into $dest_db";

    # Load in test data:
    $dbh = DBI->connect("dbi:Pg:dbname=agnes_test"); # TODO: set up test_runneraccount 
    my $td = Tests::Utils::TestData->new($dbh);
    $td->add_test_accounts();
    $dbh->disconnect;

    # Point config to new db
    App::Agnes::Config->new->{db_conn} = sub {
        return "dbi:Pg:dbname=agnes_test";
    };
    Model->reconnect;
}

sub tear_down_db : Test(shutdown) {
    Model->schema->storage->disconnect;
    my $dbh = DBI->connect("dbi:Pg:dbname=postgres"); # TODO: set up test_runneraccount 
    $dbh->do("DROP DATABASE agnes_test");
    $dbh->disconnect;
}

# wrap each test in a txn
sub setup : Test(setup) {
    Model->schema->storage->txn_begin;
}

sub teardown : Test(teardown) {
    Model->schema->storage->txn_rollback;
    Model->schema->storage->disconnect;
}


1;
