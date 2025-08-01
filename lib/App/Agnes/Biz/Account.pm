package App::Agnes::Biz::Account;

use strict;
use warnings;

use base 'App::Agnes::Biz';
use aliased 'App::Agnes::Model';
use aliased 'App::Agnes::Biz::Attribute';

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
    unless (Model->rs('Account')->username_available($account->{username})) {
        return BizResult->new(err => "ECONFLICT", msg => "Username ($username) is already in use.");
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
    #   * every required attribute is provided
    #   * every attribute is the correct type
    my @account_type_attributes = $at->account_type_attributes->search({},{ prefetch => 'attribute' })->all;
    for my $ata (@account_type_attributes) {
        my $name = $ata->attribute->name;
        my $type = $ata->attribute->type;
        my $attr = $account->{attributes}{$name};
        if ($ata->required && !defined($attr)) {
            return BizResult->new(err => 'EBADREQUEST', msg => "Missing required attribute '$name'.");
        }

        my $is_valid = Attribute->is_valid_type( type => $type, attr => $attr);
        unless ($is_valid) {
            return BizResult->new(err => 'EBADREQUEST', msg => "Attribute '$name' of type '$type' is invalid");
        }
    }

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
