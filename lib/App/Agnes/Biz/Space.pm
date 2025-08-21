package App::Agnes::Biz::Space;

use strict;
use warnings;

use base 'App::Agnes::Biz';


sub create_space {
    my $self = shift;
    my %params = @_;
    my $current_account = $params{current_account};
    my $space = $params{space};


    unless($current_account->has_permission('CREATE_TOP_LEVEL_SPACE')) {
        return BizResult->new(
            err => 'ENOTAUTHORIZED',
            msg => 'Account ' . $current_account->username . ' does not have the permission '
                 . 'CREATE_TOP_LEVEL_SPACE required to perform this operation.',
        );
    }

    return BizResult->new(res => { space => $space } );
}

1;
