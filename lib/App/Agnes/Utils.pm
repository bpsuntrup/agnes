package App::Agnes::Utils;

use strict;
use warnings;

use FindBin qw/$Bin/;

use base 'Exporter';
our @EXPORT_OK = qw/ app_base /;

sub app_base {
    return "$Bin/../lib";
}

1;

