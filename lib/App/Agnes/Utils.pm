package App::Agnes::Utils;

use strict;
use warnings;

use FindBin qw/$Bin/;
use DateTime::Format::Strptime;

use base 'Exporter';
our @EXPORT_OK = qw/ app_base is_valid_date /;

sub app_base {
    return "$Bin/../lib";
}

# only accept dates like 2020-01-25
sub is_valid_date {
    my $date_string = shift;
    my $fmt = DateTime::Format::Strptime->new(
        pattern => '%Y-%m-%d',
        strict  => 1,
        on_error => sub {},
    );
    my $dt = $fmt->parse_datetime($date_string);
    return defined($dt);
}

1;

