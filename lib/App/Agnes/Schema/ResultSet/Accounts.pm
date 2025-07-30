package App::Agnes::Schema::ResultSet::Accounts;

use strict;
use warnings;

use base 'DBIx::Class::ResultSet';


sub name_available {
    return 1;
}


1;
