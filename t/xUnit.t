use strict;
use warnings;

use FindBin qw($Dir);
use lib "$Dir/lib";

use Tests::App::Agnes;
use Tests::App::Agnes::Controller::Account;
use Tests::App::Agnes::Controller::Login;


Test::Class->runtests;
