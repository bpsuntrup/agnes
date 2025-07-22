package Tests::App::Agnes::Controller::User;

use strict;
use warnings;

use Tests::TestData;

use base qw(Test::Class);
use Test::More;
use Test::Mojo;
use DBI;
use App::Agnes::Config;
use aliased 'App::Agnes::Model';
use Mojo::JSON qw/to_json/;

# TODO: these startup, shutdown, setup, teardown methods are copied from Tests::App::Agnes,
# and should really be put in a base class
###########################################################################################
sub set_up_db : Test(startup) {
    # Create database:
    my $dbh = DBI->connect("dbi:Pg:dbname=postgres"); # TODO: set up test_runner user
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
    $dbh = DBI->connect("dbi:Pg:dbname=agnes_test"); # TODO: set up test_runner user
    my $td = Tests::TestData->new($dbh);
    $td->add_test_users();
    $dbh->disconnect;

    # Point config to new db
    App::Agnes::Config->new->{db_conn} = sub {
        return "dbi:Pg:dbname=agnes_test";
    };
    Model->reconnect;
}

sub tear_down_db : Test(shutdown) {
    Model->schema->storage->disconnect;
    my $dbh = DBI->connect("dbi:Pg:dbname=postgres"); # TODO: set up test_runner user
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
###########################################################################################


sub get_users :Tests {
    my $t = Test::Mojo->new('App::Agnes');
    $t->app->log->level('fatal');
    $t->get_ok('/users')->status_is(401, "Sad path get users");
    $t->post_ok('/login' => form => {
        username => "mary",
        password => "pass1",
    })->status_is(302)
      ->header_like('Set-Cookie' => qr/mojolicious=/, 'got session cookie');
    $t->get_ok('/users')->status_is(200)
                        ->json_has('/data/0/username', 'can get a username');
}

sub create_user : Tests {
    my $t = Test::Mojo->new('App::Agnes');
    $t->app->log->level('error');
    $t->post_ok("/users" => json => {
        user => {
            username    => "mildred",
            password    => "millypass1",
            displayname => "Mildred Suntrup",
            birthdate   => "2 Dec 2020",
            email       => 'milly@suntrup.net',
            user_type_id   => 1,
        },
    })->status_is(200, "Able to create user with POST /users");

    my $user = Model->schema->resultset('User')->search({
        username => 'mildred',
    })->first;

    is($user->displayname, 'Mildred Suntrup', "Able to get user out of database");
    isnt($user->password, 'millypass1', "Passwords should not be stored in clear text");
}



1;
