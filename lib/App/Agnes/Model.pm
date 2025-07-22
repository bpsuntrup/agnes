package App::Agnes::Model;
use App::Agnes::Config;
use aliased 'App::Agnes::Schema';

my @db_conn = App::Agnes::Config->new->{db_conn}->();
our $schema = Schema->connect(@db_conn);

sub schema {
    return $schema;
}

sub reconnect {
    my @db_conn = App::Agnes::Config->new->{db_conn}->();
    $schema = Schema->connect(@db_conn);
}
1;
