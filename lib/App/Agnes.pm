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

    my $authenticate = sub {
        my $c = shift;
        print("BENJAMIN: inside auth\n");
        return 1 if $c->session('username');
        print("BENJAMIN: no username\n");

        # TODO: support bearer-token authentication as well here.
        # TODO: set up user in stash here

        $c->render(
            json => { 
                error => "ENOLOGIN",
                message => "Please log in.",
            },
            status => 401
        );

        return undef;
    };

    my $auth = $r->under($authenticate);

    my $apiv1 = $auth->under('/api/v1');

    # Normal route to controller
    $r->get('/')->to('main#index');
    $r->post('/login')->to('login#login_now');
    $r->post('/api/v1/login')->to('login#login_api');

    $auth->get('/login')->to('login#login_ok');
    $auth->post('/users')->to('user#create_user');
    $auth->get('/users')->to('user#get_users');
}


1;
