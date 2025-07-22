package App::Agnes::DB;

use strict;
use warnings;

use base 'Exporter';
use feature 'state';
our @EXPORT_OK = qw/ dbh $dbh last_id /;

use DBI;
use Scope::Guard;

our $dbh = _connect();

sub dbh {
    my ($class, %params) = @_;
    if ($params{reconnect}) {
        $dbh->disconnect;
        $dbh = _connect();
    }
    return $dbh;
}

sub _connect {
    my $dbname = 'agnes';
    my $dbh = DBI->connect("dbi:Pg:dbname=$dbname", '','',
                           {RaiseError => 1, AutoCommit => 1});
    if (!$dbh) {
        die "Failed to connect to database: ", DBI->errstr();
    }
    return $dbh;
}

1;
