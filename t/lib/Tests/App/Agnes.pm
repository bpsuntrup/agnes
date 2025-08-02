package Tests::App::Agnes;

use strict;
use warnings;

use Tests::Utils::TestData;


use base 'Tests::Utils::CommonBase';
use Test::More;
use Test::Mojo;
use DBI;
use App::Agnes::Config;
use aliased 'App::Agnes::Model';
use Mojo::JSON qw/to_json/;

sub db_is_set_up :Tests {
    my $dbh = DBI->connect("dbi:Pg:dbname=agnes_test");
    my $accounts = $dbh->selectall_arrayref("select * from accounts");
    is (scalar @$accounts, 3, "got 3 accounts as expected");

    $dbh->disconnect;
}

sub can_get_account :Tests {
    my $schema = Model->schema;
    my $account = $schema->resultset('Account')->search({
        username => 'mary',
    })->first;
    is($account->is_admin, 1, 'can get individual account from search');

    my @accounts = $schema->resultset('Account')->all;
    is(scalar @accounts, 3, "Got 3 accounts");
    is($accounts[0]->username, 'mary', "First account is correctly named");
}

sub test_config :Tests {
    my $conf = App::Agnes::Config->new;
    is($conf->{saint}, "agnes", "Can read config");
    $conf->{saint} = 'winifred';
    my $conf2 = App::Agnes::Config->new;
    is($conf2->{saint}, "winifred", "Can change config");
    like([$conf2->{db_conn}->()]->[0], qr/agnes_test/, "I have the correct db connection config");
}


1;
