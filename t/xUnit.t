use strict;
use warnings;

use FindBin qw($Dir);
use lib "$Dir/lib";

use Tests::App::Agnes;
use Tests::App::Agnes::Controller::User;


Test::Class->runtests;
