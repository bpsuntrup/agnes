package App::Agnes::Controller::Account;

use strict;
use warnings;

use Mojo::Base 'Mojolicious::Controller';

# GET /accounts
sub get_accounts {
    my $c = shift;
    my $username = $c->session('username');
    if ($username) {
        my $accounts = {
            data => [
                {
                    username => $username,
                },
            ],
        };
        return $c->render(json => $accounts);
    }
    else {
        return $c->render(json => { error => "Unauthorized" }, status => 401);
    }
}

# POST /accounts
sub create_account {
    my $c = shift;

    unless ($c->current_account->has_permission('CREATE_ACCOUNT')) {
        return $c->render(
            json => {
                'error' => 'ENOTAUTHORIZED',
            },
            status => 403,
        );
    }

    my $data = $c->req->json;
    $data = $data->{account};

    my $accounttypeid = $data->{account_type_id};
    my $accounttype = $c->schema->resultset('AccountType')->find({
        account_type_id => $accounttypeid
    });

    #my $required_attributes = $accounttype->required_attributes;

    my %account = (
        username     => $data->{username},
        password     => $data->{password},
        displayname  => $data->{displayname},
        birthdate    => $data->{birthdate},
        email        => $data->{email},
        account_type_id => $data->{account_type_id},
    );

    $c->schema->resultset('Account')->create(\%account);
    return $c->render(text => "OK", status => 200);
}

1;
