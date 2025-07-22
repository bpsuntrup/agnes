package App::Agnes;

use strict;
use warnings;
use feature 'state';

use Mojo::Base 'Mojolicious';
use Mojo::Pg;
use App::Agnes::DB;
use App::Agnes::Config;
use aliased 'App::Agnes::Model';

# This method will run once at server start
sub startup {
    my $self = shift;
    my $config = App::Agnes::Config->new;

    my $template_path = File::Spec->catdir($self->home, 'templates');
    $self->renderer->paths([$template_path]);

    $self->helper( db => sub {
        App::Agnes::DB->dbh;
    });

    $self->helper( current_user => sub {
        my $c = shift;
        return $c->session('username');
    });

    $self->helper( schema => sub {
        state $schema = Model->schema
    });

    $self->helper( config => sub {
        return $config;
    });

    # Router
    my $r = $self->routes;

    my $auth = $r->under(sub {
        my $c = shift;
        return 1 if $c->session('username');

        # TODO: support bearer-token authentication as well here.
        # TODO: set up user in stash here

        $c->render(json => { 
            error => "ENOLOGIN",
            message => "Please log in.",
            status => 401
        });
        return undef;
    });

    my $apiv1 = $auth->under('/api/v1');

    # Normal route to controller
    $r->get('/')->to('main#index');
    $r->post('/login')->to('login#login_now');
    $r->post('/users')->to('user#create_user');
    $r->get('/users')->to('user#get_users');


    $r->post('/user')->to('user#create_user_now');
    $r->post('/unlogin')->to('login#log_out');
    $r->delete('/login')->to('login#log_out');


    # These need to be protected by auth. Need to check cookies before rendering,
    # if auth fails, give a reason (session expired or not authorized) then direct
    # to /login TODO: figure out how to do that up at this level
    $r->get('/blurbs')->to('blurbs#blurbs');
    $r->post('/blurb')->to('blurbs#add_blurb');
    $r->delete('/blurb/:blurb_id')->to('blurbs#delete_blurb');
}


1;
