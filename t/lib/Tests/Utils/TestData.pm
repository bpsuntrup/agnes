package Tests::Utils::TestData;

=pod

my $td = Tests::TestData->new($dbh);
$td->add_test_accounts;

=cut

use aliased 'App::Agnes::Biz::Password';

sub new {
    my ($class, $dbh) = @_;
    return bless {
        dbh => $dbh,
    }, $class;
}

our $TENANT_ID;

sub tenant_id {
    return $TENANT_ID;
}

sub add_test_accounts {
    my $self = shift;
    $self->{dbh}->do("
        INSERT INTO tenants
        (name)
        VALUES
        ('test_tenant_1')
    ");
    my $t_id = $self->{dbh}->selectrow_array(" SELECT tenant_id from tenants where name = 'test_tenant_1'");
    $TENANT_ID = $t_id;
    $self->{dbh}->do("
        INSERT INTO account_types
        (name, tenant_id)
        VALUES
        ('faithful', '$t_id'),
        ('priest', '$t_id'),
        ('bishop', '$t_id'),
        ('has_required_attrs', '$t_id'),
        ('no_required_attrs', '$t_id')
    ");
    my $pass1 = Password->enhashen(password => 'pass1');
    my $pass2 = Password->enhashen(password => 'pass2');
    my $pass3 = Password->enhashen(password => 'pass3');
    $self->{dbh}->do("
        INSERT INTO accounts
        ( username ,password ,account_type_id, is_admin, tenant_id)
        VALUES
        ( 'mary', '$pass1', 1, true, '$t_id'),  -- admin
        ( 'joe',  '$pass2', 2, false, '$t_id'), -- highly privileged non admin
        ( 'john', '$pass3', 3, false, '$t_id')  -- no privs
    ");
    $self->{dbh}->do(qq{
        INSERT INTO attributes
        (name, type, tenant_id)
        VALUES
        ('reception_date', 'date', '$t_id'),
        ('marital_status', 'enum("married", "unmarried")', '$t_id'),
        ('christian_name', 'text', '$t_id'),
        ('fav_book', 'text', '$t_id')
    });
    $self->{dbh}->do("
        INSERT INTO permissions
        (permission)
        VALUES
        ('CREATE_ACCOUNT'),
        ('DELETE_ACCOUNT')
        ");
    $self->{dbh}->do("
        INSERT INTO roles
        (name, tenant_id)
        VALUES
        ('bishop', '$t_id')
    ");
    $self->{dbh}->do("
        INSERT INTO account_roles
        (account_id, role_id)
        SELECT accounts.account_id,
               roles.role_id
        FROM accounts
        JOIN roles ON accounts.username = 'joe' AND roles.name = 'bishop'
    ");
    $self->{dbh}->do("
        INSERT INTO role_permissions
        (role_id, permission_id)
        SELECT roles.role_id,
               permissions.permission_id
        FROM permissions
        CROSS JOIN roles
        WHERE
        (permissions.permission='CREATE_ACCOUNT' AND roles.name = 'bishop') OR
        (permissions.permission='DELETE_ACCOUNT' AND roles.name = 'bishop')
    ");

    # Add required attributes
    $self->{dbh}->do(" 
        INSERT INTO account_type_attributes
        (account_type_id, attribute_id, required)
        SELECT at.account_type_id, att.attribute_id, true
        FROM account_types at CROSS JOIN attributes att
        WHERE
        (at.name = 'has_required_attrs' AND att.name = 'christian_name') OR
        (at.name = 'has_required_attrs' AND att.name = 'reception_date')
    ");
    # Add non required attributes
    $self->{dbh}->do(" 
        INSERT INTO account_type_attributes
        (account_type_id, attribute_id, required)
        SELECT at.account_type_id, att.attribute_id, false
        FROM account_types at CROSS JOIN attributes att
        WHERE
        (at.name = 'has_required_attrs' AND att.name = 'fav_book')
    ");
    #$self->{dbh}->do(" ");
    #$self->{dbh}->do(" ");
}

1;
