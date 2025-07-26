package Tests::Utils::TestData;

=pod

my $td = Tests::TestData->new($dbh);
$td->add_test_users;

=cut

sub new {
    my ($class, $dbh) = @_;
    return bless {
        dbh => $dbh,
    }, $class;
}

sub add_test_users {
    my $self = shift;
    $self->{dbh}->do("
        INSERT INTO user_types
        (name)
        VALUES
        ('faithful'),
        ('priest'),
        ('bishop'),
        ('has_required_attrs')
    ");
    $self->{dbh}->do("
        INSERT INTO users
        ( username ,password ,user_type_id, is_admin )
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
        ('CREATE_USER')
        ");
    $self->{dbh}->do("
        INSERT INTO roles
        (name)
        VALUES
        ('bishop')
    ");
    $self->{dbh}->do("
        INSERT INTO user_roles
        (user_id, role_id)
        SELECT users.user_id,
               roles.role_id
        FROM users
        JOIN roles ON users.username = 'joe' AND roles.name = 'bishop'
    ");
    #$self->{dbh}->do(" ");
    #$self->{dbh}->do(" ");
    #$self->{dbh}->do(" ");
}

1;
