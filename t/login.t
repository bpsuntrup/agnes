use Mojo::Base -strict;

use Test::More;
use Test::Mojo;


my $t = Test::Mojo->new('App::Agnes');

$t->get_ok('/users/')->status_is(401, "Sad path get users");

$t->post_ok('/login' => form => {
    username => "agnes",
    password => "suntrup",
})->status_is(302)
  ->header_like('Set-Cookie' => qr/mojolicious=/, 'got session cookie');

$t->get_ok('/users')->status_is(200)
                    ->json_has('/data/0/username', 'can get a username');



done_testing();
