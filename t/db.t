use strict;
use warnings;

use Test::More;
use App::Agnes::DB;

my $dbh;
eval {
    $dbh = App::Agnes::DB->dbh
};
if ($@) {
    fail("Failed to connect to database: " . $@);
}

my $num_users = $dbh->do("select count(*) from users");
ok($num_users, "Can select users");

done_testing;
