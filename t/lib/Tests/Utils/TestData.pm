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
        ( username ,password ,user_type_id )
        VALUES
        ( 'mary', 'pass1', 1),
        ( 'joe',  'pass2', 2),
        ( 'john', 'pass3', 3)
    ");
    $self->{dbh}->do(q{
        INSERT INTO attributes
        (name, type)
        VALUES
        ('reception_date', 'date'),
        ('marital_status', 'enum("married", "unmarried")'),
        ('christian_name', 'text')
    });
    $self->{dbh}->do(" ");
}

1;
