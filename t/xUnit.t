use FindBin qw($Dir);
use lib "$Dir/lib";

use Tests::App::Agnes;


Test::Class->runtests;
