=head1 create_account.pl username password account_type tenant_name

script for creating an account. Depends on a user named "agnes" existing in the database and
tenant that you want to create an account in.

Creates an account in the 

=cut

use lib './lib';
use aliased 'App::Agnes::Biz::Account' => 'Biz';
use aliased 'App::Agnes::Model';
use JSON;

my $username = shift;
my $password = shift;
my $account_type = shift;
my $tenant_name = shift;

my $json = JSON->new->pretty;

my $tenant_id = Model->rs('Tenant')->find({name => $tenant_name})->tenant_id;
my $agnes = Model->rs('Account')->find({username => 'agnes', tenant_id => $tenant_id});
my $res = Biz->create_account(
    current_account => $agnes,
    account => {
        username        => $username,
        password        => $password,
        account_type    => $account_type,
    },
);

if ($res->err) {
    print($json->encode($res->err));
    print($json->encode($res->msg));
}
else {
    print($json->encode($res->res));
}
