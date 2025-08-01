package App::Agnes::Biz::Attribute;

use strict;
use warnings;

use base 'App::Agnes::Biz';

use App::Agnes::Utils qw/is_valid_date/;
use JSON::Parse qw/parse_json/;
use List::Util qw/any/;

# type (date, text, enum, int, boolean)
sub is_valid_type {
    my ($self, %params) = @_;
    my $type = $params{type};
    my $attr = $params{attr};

    if ($type eq 'date') {
        return is_valid_date($attr); # Must be YYYY-MM-DD
    }
    elsif ($type eq 'text') {
        return $attr ne '';
    }
    elsif ($type eq 'int') {
        return $attr =~ /^[0-9]+$/;
    }
    elsif ($type eq 'boolean') {
        return $attr eq 'true' || $attr eq 'false';
    }
    elsif ($type =~ /enum/) { # { "enum": ["val1", "val2", "val3", ... ] }
        my $enums = parse_json($type)->{enum};
        return any { $_ eq $attr } @$enums;
    }
    else {
        die "Invalid type ($type). This is BROKE.";
    }
}

1;
