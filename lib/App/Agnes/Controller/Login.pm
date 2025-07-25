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

    my $user = Model->schema->resultset('User')->search({
        username => $username,
    })->first;


    # TODO: replace with real auth
    if ($password eq $user->password) {
        $self->session(username => $username);

        return $self->redirect_to('/'); # TODO: redirect to app
    }
    else {
        my $url = $self->url_for('/')->query( login_msg => 'Invalid login credentials' );
        return $self->redirect_to($url);
    }
}

# POST /api/v1/login
# TODO: not right now. 
sub login_api {
    my $c = shift;

    # Check JSON first
    my $user = $c->req->json->{user};

    my $auth = Model->schema->resultset('User')->authenticate(
        username => $user->{username},
        password => $user->{password},
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
        text => 'OK',
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
