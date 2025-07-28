package App::Agnes::Biz::Account;

use strict;
use warnings;

use aliased App::Agnes::Model;

sub create_account {
    my $self = shift;
    my $account = shift;

    my $accounttype = Model->resultset('AccountType')->find({
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

    Model->resultset('Account')->create(\%account);
}


1;
