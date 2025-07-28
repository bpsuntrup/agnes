package App::Agnes::Controller::Account;

use strict;
use warnings;

use Mojo::Base 'Mojolicious::Controller';

use aliased 'App::Agnes::Biz::Account' => 'BizAccount';

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
    my $account = BizAccount->create_account($data->{account});

    return $c->render(text => "OK", status => 200);
}

1;
