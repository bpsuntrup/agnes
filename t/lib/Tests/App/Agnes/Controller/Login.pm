package Tests::App::Agnes::Controller::Login;

use strict;
use warnings;


use base 'Tests::Utils::CommonBase';
use Test::More;
use Test::Mojo;

sub test_normal_login : Tests {
    my $t = Test::Mojo->new('App::Agnes');

    note("Test login without cookie.");
    $t->get_ok('/login')
      ->status_is(401, "Cannot verify login when not logged in")
      ->json_is('/error', 'ENOLOGIN', 'Get the ENOLOGIN error json');

    note("Test logging in by getting cookie.");
    $t->post_ok('/login' => form => {
        username => "mary",
        password => "pass1",
    })->status_is(302)
      ->header_like('Set-Cookie' => qr/mojolicious=/, 'Normal login sets session cookie');

    note("Test cookie. Should authorize.");
    $t->get_ok('/login')
      ->status_is(200)
      ->content_like(qr/OK/, "Login set cookie and is verified");
};

# TODO: not right now.
#sub login_api : Tests {
#    my $t = Test::Mojo->new('App::Agnes');
#    $t->post_ok('/api/v1/login' => json => {
#        username => "mary",
#        password => "pass1",
#    })->status_is(200)
#      ->content_type_is('application/json')
#      ->header_like('Bearer' => qr/mojolicious=/, 'got session cookie');
#}

1;
