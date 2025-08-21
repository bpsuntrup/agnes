package App::Agnes;

use strict;
use warnings;
use feature 'state';

use Mojo::Base 'Mojolicious';
use Mojo::Pg;
use App::Agnes::DB;
use App::Agnes::Config;
use aliased 'App::Agnes::Model';
use App::Agnes::Error qw/error_code_to_http/;

# This method will run once at server start
sub startup {
    my $self = shift;
    my $config = App::Agnes::Config->new;

    # Set up template dir
    my $template_path = File::Spec->catdir($self->home, 'templates');
    $self->renderer->paths([$template_path]);

    # Set up openapi spec dir
    my $openapi3_path = $self->home->rel_file('openapi3/agnes.yaml');
    $self->plugin(OpenAPI => {url => $openapi3_path});


    $self->helper( db => sub {
        App::Agnes::DB->dbh;
    });

    $self->helper( current_account => sub {
        my $c = shift;

        my $ca;
        if ($ca = $c->stash('current_account')) {
            return $ca;
        }
        else {
            $ca = Model->rs('Account')->find({
                username => $c->session('username'),
                tenant_id => $c->session('tenant_id'),
            });
            $c->stash('current_account', $ca);
            return $ca
        }
    });

    $self->helper( schema => sub {
        state $schema = Model->schema
    });

    $self->helper( config => sub {
        return $config;
    });

    $self->helper(render_error => sub {
        my $c = shift;
        my %params = @_;
        return $c->render(
            json => {
                err => $params{err},
                msg => $params{msg},
            },
            status => error_code_to_http($params{err}),
        );
    });

    # Router
    my $r = $self->routes;

    my $authenticate = sub {
        my $c = shift;
        return 1 if $c->session('username');

        # TODO: support bearer-token authentication as well here.
        # TODO: set up account in stash here

        $c->render_error( err => "ENOLOGIN", msg => "Please log in.");

        return undef;
    };

    my $auth = $r->under($authenticate);

    my $restv1 = $auth->under('/api/rest/v1');

    # Normal route to controller
    $r->get('/')->to('main#index');
    $r->post('/login')->to('login#login_now');
    $r->post('/api/v1/login')->to('login#login_api');

    $auth->get('/login')->to('login#login_ok');
    $restv1->post('/account')->to('account#create_account'); # TODO: change to accounts
    $restv1->get('/accounts')->to('account#get_accounts');
    $restv1->get('/account/:account_id')->to('account#get_account');
    $restv1->put('/account/:account_id')->to('account#update_account');
    $restv1->delete('/account/:account_id')->to('account#deactivate_account');

    $restv1->post('/spaces')->to('space#create_space');
}


1;
