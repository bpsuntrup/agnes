package Tests::App::Agnes::Controller::Account;

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

#sub get_accounts :Tests {
#    my $t = Test::Mojo->new('App::Agnes');
#    $t->app->log->level('fatal');
#    $t->get_ok('/accounts')->status_is(401, "Sad path get accounts");
#
#    $t->post_ok('/login' => form => {
#        username => "mary",
#        password => "pass1",
#    })->status_is(302)
#      ->header_like('Set-Cookie' => qr/mojolicious=/, 'got session cookie');
#    $t->get_ok('/accounts')->status_is(200)
#                        ->json_has('/data/0/username', 'can get a username');
#}

#sub create_account : Tests {
#    my $t = Test::Mojo->new('App::Agnes');
#    $t->post_ok("/accounts" => json => {
#        account => {
#            username    => "mildred",
#            password    => "millypass1",
#            displayname => "Mildred Suntrup",
#            birthdate   => "2 Dec 2020",
#            email       => 'milly@suntrup.net',
#            account_type_id   => 1,
#        },
#    })->status_is(200, "Able to create account with POST /accounts");
#
#    my $account = Model->schema->resultset('Account')->search({
#        username => 'mildred',
#    })->first;
#
#    is($account->displayname, 'Mildred Suntrup', "Able to get account out of database");
#    isnt($account->password, 'millypass1', "Passwords should not be stored in clear text");
#}

sub create_account_sad : Tests {
    my $t = Test::Mojo->new('App::Agnes');

    note("Create account should fail when not logged in.");
    $t->post_ok("/api/v1/accounts" => json => {
        account => {
            username    => "mildred",
            password    => "millypass1",
            displayname => "Mildred Suntrup",
            birthdate   => "2 Dec 2020",
            email       => 'milly@suntrup.net',
            account_type_id   => 1,
        },
    })->status_is(401, "Create account fails when not logged in.")
      ->json_is('/err', 'ENOLOGIN', "Get ENOLOGIN on failure to log in");

    note("Create account fails when logged in with non-admin account.");
    $t->post_ok('/login' => form => {
        username => "joe",
        password => "pass2",
    })->status_is(302);
    $t->post_ok("/api/v1/accounts" => json => {
        account => {
            username    => "mildred",
            password    => "millypass1",
            displayname => "Mildred Suntrup",
            birthdate   => "2 Dec 2020",
            email       => 'milly@suntrup.net',
            account_type_id   => 1,
        },
    })->status_is(403, "Not authorized to create account with unpriveledged account")
      ->json_is('/err', 'ENOTAUTHORIZED', "Get ENOTAUTHORIZED");

    note("Create account fails when required column is missing....");
    note("Required columns are username, password, and account_type.");
    $t->post_ok('/login' => form => {
        username => "mary",
        password => "pass1",
    })->status_is(302);
    $t->get_ok("/login")->status_is(200)->content_like(qr/mary/);
    $t->post_ok("/api/v1/accounts" => json => {
        account => {
            username    => "mildred",
            password    => "millypass1",
            displayname => "Mildred Suntrup",
            birthdate   => "2 Dec 2020",
            email       => 'milly@suntrup.net',
        },
    })->status_is(400, "Fails to create an account without an account_type")
      ->json_is('/err', 'EBADREQUEST', "Get EBADREQUEST");
    $t->post_ok("/api/v1/accounts" => json => {
        account => {
            username    => "mildred",
            password    => "millypass1",
            displayname => "Mildred Suntrup",
            birthdate   => "2 Dec 2020",
            email       => 'milly@suntrup.net',
            account_type_id   => 1337,
        },
    })->status_is(400, "Fails to create an account with an invalid account_type")
      ->json_is('/err', 'EBADREQUEST', "Get EBADREQUEST");

    note("Create account fails when required attribute is missing.");
    $t->post_ok("/api/v1/accounts" => json => {
        account => {
            username    => "mildred",
            password    => "millypass1",
            displayname => "Mildred Suntrup",
            birthdate   => "2 Dec 2020",
            email       => 'milly@suntrup.net',
            account_type_id   => 4, # has_required_attrs
            attributes => {
                fav_book => "Goodnight Moon"
                # Missing christian_name
            },
        },
    })->status_is(400, "Fails to create an account with missing required attribute")
      ->json_is('/err', 'EBADREQUEST', "Get EBADREQUEST");

    note("Create account fails when attribute is wrong type.");
    $t->post_ok("/api/v1/accounts" => json => {
        account => {
            username    => "mildred",
            password    => "millypass1",
            displayname => "Mildred Suntrup",
            birthdate   => "2 Dec 2020",
            email       => 'milly@suntrup.net',
            account_type_id   => 4, # has_required_attrs
            attributes => {
                fav_book => "Goodnight Moon",
                christian_name => "Mildred",
                reception_date => "Not a date",
            },
        },
    })->status_is(400, "Fails to create an account with bad date type")
      ->json_is('/err', 'EBADREQUEST', "Get EBADREQUEST");

    note("TODO: test that you can't create a user with the same username");
    note("TODO: test all the types, enum, date, boolean for validity here");

    note("TODO: test openapi validation");
}

sub create_account_happy : Tests {
    note("Create account works when logged in with admin account and all required fields are included");
    note("Create account works when logged in with privileged nonadmin account and all required fields are included");
    note("Account exists and has attributes you'd expect");
    note("Create account does not fail when you don't include nonrequired attributes");
}



# * create users
# 	* guarded by user_create role
# 		* errors when user without user_create or admin does it
# 	* must require required attributes
# 		* errors when not all required attributes are provided
# 	* must reject when invalid attributes
# 		* invalid, because not on type
# 		* invalid, because wrong type
# 	* must be logged in
# * read users
# 	* search for users by attribute
# 	* must be logged in
# * delete users
# 	* must be logged in
# 	* must have admin or user_delete role
# 		* errors when not
# 	* must delete all user_attributes too
# 	* user must be left in system with only username and null password, and "deleted" user type
# * update users
# 	* must be logged in
# 	* must require required attributes
# 		* cannot set required attribute to empty
# 	* must reject when invalid attributes
# 		* invalid, because not on type
# 		* invalid, because wrong type


1;
