use strict;
use warnings;

package Tests::Utils::Loader;
use base qw/ Test::Class::Load /;

sub is_test_class {
    my ($class, $file, $dir ) = @_;
    return ($file =~ /\.pm$/) && ($file =~ /App/);
}

1;
