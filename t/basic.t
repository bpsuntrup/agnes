use Mojo::Base -strict;

use Test::More;
use Test::Mojo;
use Test::Mojo::WithRoles 'Debug';

BEGIN {$ENV{BLURBLE_SET_CONFIG} = 'dbname,q(testdb)'}

use App::Blurble::Config qw/config/;
use aliased 'App::Blurble::Model::Init';
use aliased 'App::Blurble::Model::ResultSet::Users';

my $t = Test::Mojo::WithRoles->new('App::Blurble');

is(config()->{dbname}, 'testdb', 'connected to test db');

Init->init_db;

# test create user with bad username
$t->ua->max_redirects(1);
$t->post_ok('/user' => form => 
    { username => '8badname',
      password => 's00cr3t', });
$t->status_is(200)->text_like('#user_msg' =>  qr/Username is invalid/);

# test create user
$t->post_ok('/user' => form => 
    { username => 'mickeymouse',
      password => 's3cr3t', });
$t->status_is(200)->text_like('#top_msg' => qr/User mickeymouse created successfully/);

my $user = Users->get_by_username('mickeymouse', password_please => 1);
is($user->{username}, 'mickeymouse', 'user is in database');
isnt($user->{password}, 's3cr3t', 'password is unreadable');

# test create user with same username
$t->post_ok('/user' => form => 
    { username => 'mickeymouse',
      password => 's3cr11t', });
$t->status_is(200)->text_like('#user_msg' => qr/Username exists./);

# Log in with nonexistant user
$t->get_ok('/login', form => {
    username => 'donaldduck',
    password => 'st00p1db3rd',
})->status_is(200)->text_like('#login_msg' => qr/Invalid login credentials/) or diag("log in with nonexistant user");

# test login with wrong password
$t->get_ok('/login', form => {
    username => 'mickeymouse',
    password => 'wr0ngP455_dUd3',
})->status_is(200)->text_like('#login_msg' => qr/Invalid login credentials/);

# test happy login 
$t->get_ok('/login', form => {
    username => 'mickeymouse',
    password => 's3cr3t',
})->status_is(200)->text_like('head title' => qr/Blurbs by mickeymouse/);

# test logout
$t->post_ok('/unlogin')->status_is(200)->text_like('header h1' => qr'This is Blurble.');

# see if we're really logged out
$t->get_ok('/blurbs')->status_is(200)->text_like('#top_msg' => qr'You do not have permission to view this page.');

# test login with whitespace and wrong case in username
$t->get_ok('/login', form => {
    username => ' MickeyMouse   ',
    password => 's3cr3t',
})->status_is(200)->text_like('head title' => qr/Blurbs by mickeymouse/);

# test add blurb
$t->post_ok('/blurb', json => {
    blurb_content => "Pluto is a g00d doggie."
})->status_is(200);

$t->get_ok('/blurbs', {'Content-Type', 'application/json'})
  ->status_is(200)
  ->content_type_like(qr'application/json')->da # BENJAMIN TODO: cleanup ->da
  ->json_has('/blurbs/0');

# test delete blurb
$t->delete_ok('/blurb/1')->status_is(200);

$t->get_ok('/blurbs', {'Content-Type', 'application/json'})
  ->status_is(200)
  ->content_type_like(qr'application/json')
  ->json_hasnt('/blurbs/0');

Init->init_db;

# destroy database
unlink 'testdb';


done_testing();
