package App::Agnes::Utils;

use strict;
use warnings;

use FindBin qw/$Bin/;
use DateTime::Format::Strptime;

use base 'Exporter';
our @EXPORT_OK = qw/ app_base is_valid_date is_valid_uuid/;

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

# should have standard postgres form bcfcada6-31de-463c-a02d-b2a5673cea9f
sub is_valid_uuid {
    my $uuid = shift;
    my $hex = qr/[a-f0-9]/;
    return $uuid =~ /$hex {8} -
                     $hex {4} -
                     $hex {4} -
                     $hex {4} -
                     $hex {12} /x;
}

1;

