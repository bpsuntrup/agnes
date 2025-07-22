package App::Agnes::Controller::Login;

use strict;
use warnings;

use Mojo::Base 'Mojolicious::Controller';

use aliased 'App::Agnes::Model';

# GET /login
# if successful, gives auth cookie, redirects to /blurbs
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

# DELETE /login
# POST   /unlogin
sub log_out {
    my $self = shift;
    delete $self->session->{username};
    return $self->redirect_to('/');
}

1;
