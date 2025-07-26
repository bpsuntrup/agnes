package Tests::Utils::TestData;

=pod

my $td = Tests::TestData->new($dbh);
$td->add_test_accounts;

=cut

sub new {
    my ($class, $dbh) = @_;
    return bless {
        dbh => $dbh,
    }, $class;
}

sub add_test_accounts {
    my $self = shift;
    $self->{dbh}->do("
        INSERT INTO account_types
        (name)
        VALUES
        ('faithful'),
        ('priest'),
        ('bishop'),
        ('has_required_attrs')
    ");
    $self->{dbh}->do("
        INSERT INTO accounts
        ( username ,password ,account_type_id, is_admin )
        VALUES
        ( 'mary', 'pass1', 1, true),  -- admin
        ( 'joe',  'pass2', 2, false), -- highly privileged non admin
        ( 'john', 'pass3', 3, false)  -- no privs
    ");
    $self->{dbh}->do(q{
        INSERT INTO attributes
        (name, type)
        VALUES
        ('reception_date', 'date'),
        ('marital_status', 'enum("married", "unmarried")'),
        ('christian_name', 'text')
    });
    $self->{dbh}->do("
        INSERT INTO permissions
        (permission)
        VALUES
        ('CREATE_ACCOUNT')
        ");
    $self->{dbh}->do("
        INSERT INTO roles
        (name)
        VALUES
        ('bishop')
    ");
    $self->{dbh}->do("
        INSERT INTO account_roles
        (account_id, role_id)
        SELECT accounts.account_id,
               roles.role_id
        FROM accounts
        JOIN roles ON accounts.accountname = 'joe' AND roles.name = 'bishop'
    ");
    #$self->{dbh}->do(" ");
    #$self->{dbh}->do(" ");
    #$self->{dbh}->do(" ");
}

1;
