package App::Agnes::Schema::ResultSet::Accounts;

use strict;
use warnings;

use base 'DBIx::Class::ResultSet';


sub username_available {
    my $self = shift;
    my $username = shift;

    return $self->find({ username => $username }) ? 0 : 1;
}


1;
