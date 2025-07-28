package App::Agnes::Biz::Account;

use strict;
use warnings;

use base 'App::Agnes::Biz';
use aliased App::Agnes::Model;

sub create_account {
    my $self = shift;
    my %params = @_;
    my $current_account = $params{current_account};
    my $account = $params{account};

    my $permission = Model->rs("Account")
         ->find({username => $current_account})
         ->has_permission('CREATE_ACCOUNT');

    unless ($permission) {
        return BizResult->new(err => 'ENOTAUTHORIZED');
    }

    my $accounttype = Model->rs('AccountType')->find({
        account_type_id => $account->{account_type_id},
    });

    #my $required_attributes = $accounttype->required_attributes;

    my %account = (
        username        => $account->{username},
        password        => $account->{password},
        displayname     => $account->{displayname},
        birthdate       => $account->{birthdate},
        email           => $account->{email},
        account_type_id => $account->{account_type_id},
    );

    my $res = Model->rs('Account')->create(\%account);

    return BizResult->new(res => $res);
}

1;
