package App::Agnes::Controller::User;

use strict;
use warnings;

use Mojo::Base 'Mojolicious::Controller';

# GET /users
sub get_users {
    my $c = shift;
    my $username = $c->session('username');
    if ($username) {
        my $users = {
            data => [
                {
                    username => $username,
                },
            ],
        };
        return $c->render(json => $users);
    }
    else {
        return $c->render(json => { error => "Unauthorized" }, status => 401);
    }
}

# POST /users
sub create_user {
    my $c = shift;

    unless ($c->current_user->has_priv('CREATE_USER')) {
        return $c->render(
            json => {
                'error' => 'ENOTAUTHORIZED',
            },
            status => 403,
        );
    }

    my $data = $c->req->json;
    $data = $data->{user};

    my $usertypeid = $data->{user_type_id};
    my $usertype = $c->schema->resultset('UserType')->find({
        user_type_id => $usertypeid
    });

    #my $required_attributes = $usertype->required_attributes;

    my %user = (
        username     => $data->{username},
        password     => $data->{password},
        displayname  => $data->{displayname},
        birthdate    => $data->{birthdate},
        email        => $data->{email},
        user_type_id => $data->{user_type_id},
    );

    $c->schema->resultset('User')->create(\%user);
    return $c->render(text => "OK", status => 200);
}

1;
