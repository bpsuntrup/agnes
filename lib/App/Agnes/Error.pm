package App::Agnes::Error;

use strict;
use warnings;

use base 'Exporter';

our @EXPORT_OK = qw/error_code_to_http/;

our %ERROR_TO_HTTP = (
    # not sufficient privileges for user to access resource
    ENOTAUTHORIZED => 403,

    # wrong username/password
    EINVALIDCREDS => 401,

    # must be logged in to access resource
    ENOLOGIN => 401,

    # invalid data in request body
    EBADREQUEST => 400,
    EBADUUID => 400,

    # Username is taken, etc.
    ECONFLICT => 409,

    # /resource/1234, but 1234 doesn't exist
    ENOMATCHINGID => 404,
);

sub error_code_to_http {
    my $error_code = shift;

    $ERROR_TO_HTTP{$error_code} || die "invalid error code: ($error_code)";
    return $ERROR_TO_HTTP{$error_code};
}

1;
