package Tests::App::Agnes::Controller::User;

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

#sub get_users :Tests {
#    my $t = Test::Mojo->new('App::Agnes');
#    $t->app->log->level('fatal');
#    $t->get_ok('/users')->status_is(401, "Sad path get users");
#
#    $t->post_ok('/login' => form => {
#        username => "mary",
#        password => "pass1",
#    })->status_is(302)
#      ->header_like('Set-Cookie' => qr/mojolicious=/, 'got session cookie');
#    $t->get_ok('/users')->status_is(200)
#                        ->json_has('/data/0/username', 'can get a username');
#}

#sub create_user : Tests {
#    my $t = Test::Mojo->new('App::Agnes');
#    $t->post_ok("/users" => json => {
#        user => {
#            username    => "mildred",
#            password    => "millypass1",
#            displayname => "Mildred Suntrup",
#            birthdate   => "2 Dec 2020",
#            email       => 'milly@suntrup.net',
#            user_type_id   => 1,
#        },
#    })->status_is(200, "Able to create user with POST /users");
#
#    my $user = Model->schema->resultset('User')->search({
#        username => 'mildred',
#    })->first;
#
#    is($user->displayname, 'Mildred Suntrup', "Able to get user out of database");
#    isnt($user->password, 'millypass1', "Passwords should not be stored in clear text");
#}

sub create_user_sad : Tests {
    my $t = Test::Mojo->new('App::Agnes');

    note("Create user should fail when not logged in.");
    $t->post_ok("/users" => json => {
        user => {
            username    => "mildred",
            password    => "millypass1",
            displayname => "Mildred Suntrup",
            birthdate   => "2 Dec 2020",
            email       => 'milly@suntrup.net',
            user_type_id   => 1,
        },
    })->status_is(401, "Create User fails when not logged in.")
      ->json_is('/error', 'ENOLOGIN', "Get ENOLOGIN on failure to log in");

    note("Create User fails when logged in with non-admin user.");
    $t->post_ok('/login' => form => {
        username => "joe",
        password => "pass2",
    })->status_is(302);
    $t->post_ok("/users" => json => {
        user => {
            username    => "mildred",
            password    => "millypass1",
            displayname => "Mildred Suntrup",
            birthdate   => "2 Dec 2020",
            email       => 'milly@suntrup.net',
            user_type_id   => 1,
        },
    })->status_is(403, "Not authorized to create user with unpriveledged user")
      ->json_is('/error', 'ENOTAUTHORIZED', "Get ENOTAUTHORIZED");

    note("Create User fails when required column is missing.");
    note("Create User fails when required attribute is missing.");
}

sub create_user_happy : Tests {
    note("Create user works when logged in with admin user and all required fields are included");
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
