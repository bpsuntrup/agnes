package App::Agnes::Biz::Space;

use strict;
use warnings;

use base 'App::Agnes::Biz';
use aliased 'App::Agnes::Model';


sub create_space {
    my $self = shift;
    my %params = @_;
    my $current_account = $params{current_account};
    my $space = $params{space};

    if (!$space) {
        return BizResult->new(err => 'EBADREQUEST', msg => 'Bad request. See docs.');
    }


    unless($current_account->has_permission('CREATE_TOP_LEVEL_SPACE')) {
        return BizResult->new(
            err => 'ENOTAUTHORIZED',
            msg => 'Account ' . $current_account->username . ' does not have the permission '
                 . 'CREATE_TOP_LEVEL_SPACE required to perform this operation.',
        );
    }

    # Actually create the space

    my %newspace = (
        %$space,
        tenant_id => $current_account->tenant_id,
        owner_id  => $current_account->account_id,
    );
    my $resspace = Model->rs('Space')->create(\%newspace);

    $newspace{space_id} = $resspace->space_id;
    $newspace{icon} //= '';
    $newspace{subspaces} //= [];

    #TODO: handle subspaces, robustify tests

    return BizResult->new(res => { space => \%newspace } );
}

1;

__END__

=pod
=head1 NAME
App::Agnes::Biz::Space - CRUD method on Agnes Spaces

=head1 SYNOPSIS

    use aliased 'App::Agnes::Biz::Space' => 'Biz';

    $res = $agnes->create_space(current_account => $ca, space => $space);

    if ($res->err) {
        # Handle error, throw it or return HTTP code
    }
    my $space = $res->res->{space};
    ...

=head1 DESCRIPTION

Handles CRUD operations on spaces

=head1 METHODS

=head2 create_space

=cut
