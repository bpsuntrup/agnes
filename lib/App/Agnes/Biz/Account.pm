package App::Agnes::Biz::Account;

use strict;
use warnings;

use base 'App::Agnes::Biz';
use aliased 'App::Agnes::Model';

sub create_account {
    my $self = shift;
    my %params = @_;
    my $current_account = $params{current_account};
    my $account = $params{account};

    # Check perm
    my $permission = Model->rs("Account")
         ->find({username => $current_account})
         ->has_permission('CREATE_ACCOUNT');

    unless ($permission) {
        return BizResult->new(err => 'ENOTAUTHORIZED');
    }

    # Validate username
    my $username = $account->{username};
    unless ($username =~ /[A-Za-z_][A-Za-z_0-9]*/) {
        return BizResult->new(err => "EBADREQUEST", msg => "Username is invalid.");
    }
    unless (Model->rs('Account')->name_available($account->{username})) {
        return BizResult->new(err => "ECONFLICT", msg => "Username ($username) is taken already.");
    }

    # Validate password
    # TODO: make this better
    my $password = $account->{password};
    unless ($password && $password =~ /.........*/) {
        return BizResult->new(err => 'EBADREQUEST', msg => 'Must include password with at least 8 characters');
    }

    # Validate account_type
    my $account_type_name = $account->{account_type};
    my $account_type_id = $account->{account_type_id};
    my $at;
    if ($account_type_id) {
        $at = Model->rs('AccountType')->find({account_type_id => $account_type_id});
    }
    elsif ($account_type_name) {
        $at = Model->rs('AccountType')->find({account_type => $account_type_name});
    }
    else {
        return BizResult->new(err => 'EBADREQUEST', msg => 'Must include an account_type or account_type_id');
    }
    unless ($at) {
        return BizResult->new(err => 'EBADREQUEST', msg => 'Invalid account_type or account_type_id provided');
    }

    # Check attributes
    my $attributes_rs = $at->attributes;

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
