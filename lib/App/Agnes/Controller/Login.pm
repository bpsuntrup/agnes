package App::Agnes::Controller::Login;

use strict;
use warnings;

use Mojo::Base 'Mojolicious::Controller';

use aliased 'App::Agnes::Model';

# POST /login
sub login_now {
    my $self = shift;
    my $username = $self->param('username');
    my $password = $self->param('password');

    my $account = Model->schema->resultset('Account')->search({
        username => $username,
    })->first;


    # TODO: replace with real auth
    if ($password eq $account->password) {
        $self->session(username => $username);

        return $self->redirect_to('/'); # TODO: redirect to app
    }
    else {
        my $url = $self->url_for('/')->query( login_msg => 'Invalid login credentials' );
        return $self->redirect_to($url);
    }
}

# TODO: not right now. 
# POST /api/v1/login
# {
#    "account": {
#       "username": "alice",
#       "password": "secret"
#   }
# }
# 
# HTTP/1.1 200 OK
# Content-Type: application/json
# 
# {
#   "access_token": "abc123tokenvalue",
#   "token_type": "Bearer",
#   "expires_in": 3600
# }
sub login_api {
    my $c = shift;

    # Check JSON first
    my $account = $c->req->json->{account};

    my $auth = Model->schema->resultset('Account')->authenticate(
        username => $account->{username},
        password => $account->{password},
    );
    if ($auth) {
        $c->render();
    }
    else {
        $c->render(
            json => { 'error' => 'EINVALIDCREDS', },
            status => 401,
        );
    }

}

# GET /login
sub login_ok {
    my $c = shift;
    return $c->render(
        text => 'OK' . $c->current_account->username,
        status => 200,
    );
}

# DELETE /login
# POST   /unlogin
sub log_out {
    my $self = shift;
    delete $self->session->{username};
    return $self->redirect_to('/');
}

1;
