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
        return $c->render(json => { err => "Unauthorized" }, status => 401);
    }
}

# POST /accounts
sub create_account {
    my $c = shift;

    my $data = $c->req->json;

    my $res = BizAccount->create_account(account         => $data->{account},
                                         current_account => $c->current_account);
    if ($res->err) {
        return $c->render_error(err => $res->err, msg => $res->msg);
    }

    return $c->render(json => { res => $res->res }, status => 201);
}

# PUT /account/:account_id
sub update_account {
    my $c = shift;
    my $account_id = $c->param('account_id');
    my $data = $c->req->json;
    my $res = BizAccount->update_account(account_id      => $account_id,
                                         account         => $data->{account},
                                         current_account => $c->current_account);
    if ($res->err) {
        return $c->render_error(err => $res->err, msg => $res->msg);
    }

    return $c->render(json => { res => $res->res }, status => 200);
}

# DELETE /account/:account_id
sub deactivate_account {
    my $c = shift;
    my $account_id = $c->param('account_id');
    my $res = BizAccount->deactivate_account(account_id      => $account_id,
                                             current_account => $c->current_account);
    if ($res->err) {
        return $c->render_error(err => $res->err, msg => $res->msg);
    }

    return $c->render(json => { res => $res->res }, status => 204);
}

1;
