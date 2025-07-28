package App::Agnes::Biz;

use strict;
use warnings;

=head1 Base class for Biz layer

=cut

use Object::Pad;

class BizResult {
    field $err :param :reader = undef;
    field $res :param :reader = undef;
    field $msg :param :reader = undef;
}

1;
