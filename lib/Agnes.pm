use utf8;
use strict;
use warnings;
package Agnes;

=pod
=head1 NAME
Agnes - a service object for pluggable web apps

=head1 SYNOPSIS

    use Agnes;

    my $agnes = Agnes->new('dbi::Pg::dbname=agnes');

    $agnes->current_account('username14');
    my $res = $agnes->create_account(account => { ... });
    $res = $agnes->update_account(account => { ... });
    $res = $agnes->delete_account(account_id => <uuid>);
    $res = $agnes->get_accounts(query => { ... });

    if ($res->err) {
        # Handle error, throw it or return HTTP code
    }
    my $accounts = $res->res->{accounts};
    ...

=head1 VERSION
=head1 DESCRIPTION
=head1 METHODS

=cut

=head2 new

Create a new Agnes object with db connection. Takes as a parameter a DBI connection string.

=cut

sub new {
    my $class = shift;
    return bless {}, $class;
}


1;

