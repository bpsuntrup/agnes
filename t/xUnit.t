use strict;
use warnings;

use FindBin qw($Dir);
use lib "$Dir/lib";

use Tests::Utils::Loader "$Dir/lib";

Test::Class->runtests;
