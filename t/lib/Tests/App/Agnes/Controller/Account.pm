package Tests::App::Agnes::Controller::Account;

use strict;
use warnings;


use Tests::Utils::TestData;

use base 'Tests::Utils::CommonBase';
use Test::More;
use Test::Mojo;
use DBI;
use App::Agnes::Config;
use aliased 'App::Agnes::Model';
use Mojo::JSON qw/to_json/;

#sub get_accounts :Tests {
#    my $t = Test::Mojo->new('App::Agnes');
#    $t->app->log->level('fatal');
#    $t->get_ok('/accounts')->status_is(401, "Sad path get accounts");
#
#    $t->post_ok('/login' => form => {
#        username => "mary",
#        password => "pass1",
#    })->status_is(302)
#      ->header_like('Set-Cookie' => qr/mojolicious=/, 'got session cookie');
#    $t->get_ok('/accounts')->status_is(200)
#                        ->json_has('/data/0/username', 'can get a username');
#}

sub create_account_sad : Tests {
    my $self = shift;
    my $t = Test::Mojo->new('App::Agnes');

    note("Create account should fail when not logged in.");
    $t->post_ok("/api/rest/v1/account" => json => {
        account => {
            username    => "mildred",
            password    => "millypass1",
            displayname => "Mildred Suntrup",
            birthdate   => "2 Dec 2020",
            email       => 'milly@suntrup.net',
            account_type_id   => 1,
        },
    })->status_is(401, "Create account fails when not logged in.")
      ->json_is('/err', 'ENOLOGIN', "Get ENOLOGIN on failure to log in");

    note("Create account fails when logged in with non-admin account.");
    $t->post_ok('/login' => form => {
        username => "john",
        password => "pass3",
        tenant_id => $self->tenant_id(),
    })->status_is(302);
    $t->post_ok("/api/rest/v1/account" => json => {
        account => {
            username    => "mildred",
            password    => "millypass1",
            displayname => "Mildred Suntrup",
            birthdate   => "2 Dec 2020",
            email       => 'milly@suntrup.net',
            account_type_id   => 1,
        },
    })->status_is(403, "Not authorized to create account with unpriveledged account")
      ->json_is('/err', 'ENOTAUTHORIZED', "Get ENOTAUTHORIZED");

    note("Create account fails when required column is missing....");
    note("Required columns are username, password, and account_type.");
    $t->post_ok('/login' => form => {
        username => "mary",
        password => "pass1",
        tenant_id => $self->tenant_id(),
    })->status_is(302);
    $t->get_ok("/login")->status_is(200)->content_like(qr/mary/);
    $t->post_ok("/api/rest/v1/account" => json => {
        account => {
            username    => "mildred",
            password    => "millypass1",
            displayname => "Mildred Suntrup",
            birthdate   => "2 Dec 2020",
            email       => 'milly@suntrup.net',
        },
    })->status_is(400, "Fails to create an account without an account_type")
      ->json_is('/err', 'EBADREQUEST', "Get EBADREQUEST");
    $t->post_ok("/api/rest/v1/account" => json => {
        account => {
            username    => "mildred",
            password    => "millypass1",
            displayname => "Mildred Suntrup",
            birthdate   => "2 Dec 2020",
            email       => 'milly@suntrup.net',
            account_type_id   => 1337,
        },
    })->status_is(400, "Fails to create an account with an invalid account_type")
      ->json_is('/err', 'EBADREQUEST', "Get EBADREQUEST");

    note("Create account fails when required attribute is missing.");
    $t->post_ok("/api/rest/v1/account" => json => {
        account => {
            username    => "mildred",
            password    => "millypass1",
            displayname => "Mildred Suntrup",
            birthdate   => "2 Dec 2020",
            email       => 'milly@suntrup.net',
            account_type_id   => 4, # has_required_attrs
            attributes => {
                fav_book => "Goodnight Moon"
                # Missing christian_name
            },
        },
    })->status_is(400, "Fails to create an account with missing required attribute")
      ->json_is('/err', 'EBADREQUEST', "Get EBADREQUEST");

    note("Create account fails when attribute is wrong type.");
    $t->post_ok("/api/rest/v1/account" => json => {
        account => {
            username    => "mildred",
            password    => "millypass1",
            displayname => "Mildred Suntrup",
            birthdate   => "2 Dec 2020",
            email       => 'milly@suntrup.net',
            account_type_id   => 4, # has_required_attrs
            attributes => {
                fav_book => "Goodnight Moon",
                christian_name => "Mildred",
                reception_date => "Not a date",
            },
        },
    })->status_is(400, "Fails to create an account with bad date type")
      ->json_is('/err', 'EBADREQUEST', "Get EBADREQUEST")
      ->json_like('/msg', qr/invalid/, "Get invalid message");

    $t->post_ok("/api/rest/v1/account" => json => {
        account => {
            username    => "mary",
            password    => "millypass1",
            displayname => "Mildred Suntrup",
            birthdate   => "2 Dec 2020",
            email       => 'milly@suntrup.net',
            account_type_id   => 4, # has_required_attrs
            attributes => {
                fav_book => "Goodnight Moon",
                christian_name => "Mildred",
                reception_date => "1990-01-01",
            },
        },
    })->status_is(409, "Fails to create account with existing username")
      ->json_is('/err', 'ECONFLICT', "Get ECONFLICT error code")
      ->json_like('/msg', qr/already in use/, "Get proper message");

    note("TODO: test all the types, enum, date, boolean for validity here");
    note("TODO: test that you can't create an account with extra attributes not belonging to the account_type");

    note("TODO: test openapi validation");
}

sub create_account_happy : Tests {
    my $self = shift;
    my $t = Test::Mojo->new('App::Agnes');

    note("Create account works when logged in with admin account and all required fields are included");
    $t->post_ok('/login' => form => {
        username => "mary",
        password => "pass1",
        tenant_id => $self->tenant_id(),
    }, "Login with admin account");
    $t->post_ok("/api/rest/v1/account" => json => {
        account => {
            username    => "mildred",
            password    => "millypass1",
            displayname => "Mildred Suntrup",
            birthdate   => "2 Dec 2020",
            email       => 'milly@suntrup.net',
            account_type_id   => 4, # has_required_attrs
            attributes => {
                fav_book => "Goodnight Moon",
                christian_name => "Mildred",
                reception_date => "1990-01-01",
            },
        },
    })->status_is(201, "Can create user with admin account");
    $t->app->log->level('debug');
    my $milly = Model->rs('Account')->find({ username => "mildred" }, {
        prefetch => {
            account_attributes => 'attribute'
        }
    });
    is($milly->displayname, "Mildred Suntrup", "Column name stored correctly");
    isnt("millypass1", $milly->password, "Password isn't stored in database");
    my @attributes = $milly->attributes;
    my %attributes = (
        fav_book => "Goodnight Moon",
        christian_name => "Mildred",
        reception_date => "1990-01-01",
    );
    my $atts = $milly->attributes;
    is_deeply(\%attributes, $atts, "Save attributes properly.");

    $t->post_ok('/login' => form => {
        username => "joe",
        password => "pass2",
        tenant_id => $self->tenant_id(),
    }, "Login with nonadmin privileged account");
    ok(Model->rs('Account')->find({ username => 'joe' })->has_permission("CREATE_ACCOUNT"),
       "User has permission CREATE_ACCOUNT");
    $t->post_ok("/api/rest/v1/account" => json => {
        account => {
            username    => "edmund",
            password    => "edmundpass1",
            displayname => "Edmund Suntrup",
            birthdate   => "2018-05-15",
            email       => 'ed@suntrup.net',
            account_type_id   => 4, # has_required_attrs
            attributes => {
                fav_book => "Goodnight Moon",
                christian_name => "Mildred",
                reception_date => "1990-01-01",
            },
        },
    })->status_is(201, "Can create user with nonadmin privileged account")
      ->json_has("/res/account/path")
      ->json_has("/res/account/account_id")
      ->json_is("/res/account/username", "edmund")
      ->json_hasnt("/res/account/password")
      ->json_is("/res/account/birthdate", "2018-05-15")
      ->json_is("/res/account/email", 'ed@suntrup.net')
      ->json_is("/res/account/attributes/fav_book", "Goodnight Moon")
      ->json_is("/res/account/attributes/reception_date", "1990-01-01");
    my $edmund = Model->rs('Account')->find({ username => "edmund" });
    isnt("edmundpass1", $edmund->password, "Password is not saved in DB.");
    @attributes = $edmund->attributes;
    $atts = $edmund->attributes;
    is_deeply(\%attributes, $atts, "Save attributes properly.");

    note("TODO: Create account does not fail when you don't include nonrequired attributes");
}

sub delete_account : Tests {
    my $self = shift;
    my $t = Test::Mojo->new('App::Agnes');

    $t->post_ok('/login' => form => {
        username => "mary",
        password => "pass1",
        tenant_id => $self->tenant_id(),
    }, "Login with admin account");
    $t->post_ok("/api/rest/v1/account" => json => {
        account => {
            username    => "mildred",
            password    => "millypass1",
            displayname => "Mildred Suntrup",
            birthdate   => "2 Dec 2020",
            email       => 'milly@suntrup.net',
            account_type_id   => 4, # has_required_attrs
            attributes => {
                fav_book => "Goodnight Moon",
                christian_name => "Mildred",
                reception_date => "1990-01-01",
            },
        },
    }, "Create user mildred");
    my $milly_id = $t->tx->res->json->{res}{account}{account_id};
    my $milly = Model->rs('Account')->find({
        username => 'mildred',
        tenant_id => $self->tenant_id,
    });
    ok($milly->active, "milly is active");

    $t->post_ok("/api/rest/v1/account" => json => {
        account => {
            username    => "edmund",
            password    => "edmundpass1",
            displayname => "Edmund Suntrup",
            birthdate   => "2018-05-15",
            email       => 'ed@suntrup.net',
            account_type_id   => 4, # has_required_attrs
            attributes => {
                fav_book => "Goodnight Moon",
                christian_name => "Mildred",
                reception_date => "1990-01-01",
            },
        },
    }, "Create user edmund");
    my $edmund_id = $t->tx->res->json->{res}{account}{account_id};
    my $edmund = Model->rs('Account')->find({
        username => 'edmund',
        tenant_id => $self->tenant_id,
    });


    $t->post_ok('/login' => form => {
        username => "john",
        password => "pass3",
        tenant_id => $self->tenant_id(),
    }, "Login with unprivileged account");
    my $john = Model->rs('Account')->find({
        username => "john",
        tenant_id => $self->tenant_id(),
    });
    ok(!$john->has_permission('DELETE_ACCOUNT'));
    $t->delete_ok("/api/rest/v1/account/$milly_id")
      ->status_is(403)
      ->json_is('/err', 'ENOTAUTHORIZED', 'Unprivileged user cannot delete account');


    $t = Test::Mojo->new('App::Agnes');
    $t->delete_ok("/api/rest/v1/account/$milly_id")
      ->status_is(401)
      ->json_is('/err', 'ENOLOGIN', "Cannot delete if not logged in");

    # privileged user can delete milly
    $t->post_ok('/login' => form => {
        username => "joe",
        password => "pass2",
        tenant_id => $self->tenant_id(),
    }, "Login with privileged account");
    $t->delete_ok("/api/rest/v1/account/$milly_id")
      ->status_is(204, "Can delete user with privileged user.")
      ->json_has("/res")
      ->json_hasnt("/err");
    $milly->discard_changes;
    ok(!$milly->active, "mildred user has been deactivated");

    # admin can delete edmund
    $t->post_ok('/login' => form => {
        username => "mary",
        password => "pass1",
        tenant_id => $self->tenant_id(),
    }, "Login with admin account");
    $t->delete_ok("/api/rest/v1/account/$edmund_id")
      ->status_is(204, "Can delete user with admin.")
      ->json_has("/res")
      ->json_hasnt("/err");
    $edmund->discard_changes;
    ok(!$edmund->active, "edmund user has been deactivated");

    # trying to delete nonexistant account is 404
    $t->delete_ok("/api/rest/v1/account/nonsense-id-that-isnt-there")
      ->status_is(400, "Delete 400s for bad uuid")
      ->json_is("/err", 'EBADUUID')
      ->json_hasnt("/res");

    $t->delete_ok("/api/rest/v1/account/bcfcada6-31de-463c-a02d-b2a5673cea9f")
      ->status_is(404, "Delete 404s for nonexistant resource")
      ->json_is("/err", 'ENOMATCHINGID')
      ->json_hasnt("/res");
}

sub update_account : Tests {
    my $self = shift;
    my $t = Test::Mojo->new('App::Agnes');
    my $john = Model->rs('Account')->find({
        username => "john",
        tenant_id => $self->tenant_id(),
    });
    my $joe = Model->rs('Account')->find({
        username => "joe",
        tenant_id => $self->tenant_id(),
    });
    my $mary = Model->rs('Account')->find({
        username => "mary",
        tenant_id => $self->tenant_id(),
    });

    # As unprivileged user, can only modify own user
    $t->post_ok('/login' => form => {
        username => "john",
        password => "pass3",
        tenant_id => $self->tenant_id(),
    }, "Login with unprivileged account");

    $t->app->log->level('info');
    ok(!$john->has_permission('UPDATE_ACCOUNT'));
    $t->put_ok("/api/rest/v1/account/" . $mary->account_id => json => {
        account => {
            username    => "mary",
            password    => "edmundpass1",
            displayname => "Edmund Suntrup",
            birthdate   => "2018-05-15",
            email       => 'ed@suntrup.net',
            account_type_id   => 4, # has_required_attrs
            attributes => {
                fav_book => "Goodnight Moon",
                christian_name => "Mildred",
                reception_date => "1990-01-01",
            },
        },
    })->status_is(403, "Cannot update user with nonprivileged account")
      ->json_is('/err', 'ENOTAUTHORIZED');
    $mary->discard_changes;
    isnt($mary->displayname, "Edmund Suntrup", "User has not changed");
    $t->put_ok("/api/rest/v1/account/" . $john->account_id => json => {
        account => {
            username    => "john",
            password    => "edmundpass1",
            displayname => "Edmund Suntrup",
            birthdate   => "2018-05-15",
            email       => 'ed@suntrup.net',
            account_type_id   => 4, # has_required_attrs
            attributes => {
                fav_book => "Goodnight Moon",
                christian_name => "Mildred",
                reception_date => "1990-01-01",
            },
        },
    })->status_is(200, "Can update own account")
      ->json_hasnt('/err', "no error");
    $john->discard_changes;
    is($john->displayname, "Edmund Suntrup", "User has in fact changed.");

    # When has privilege UPDATE_ACCOUNTS, can update any account
    $t = Test::Mojo->new('App::Agnes');
    $t->post_ok('/login' => form => {
        username => "joe",
        password => "pass2",
        tenant_id => $self->tenant_id(),
    }, "Login with unprivileged account");
    ok($joe->has_permission('UPDATE_ACCOUNT'));
    $t->put_ok("/api/rest/v1/account/" . $john->account_id => json => {
        account => {
            username    => "john",
            password    => "edmundpass1",
            displayname => "John Suntrup",
            birthdate   => "2018-05-15",
            email       => 'ed@suntrup.net',
            account_type_id   => 4, # has_required_attrs
            attributes => {
                fav_book => "Goodnight Moon",
                christian_name => "Mildred",
                reception_date => "1990-01-01",
            },
        },
    })->status_is(200, "Can update other user's account with privileged nonadmin user")
      ->json_hasnt('/err', "no error");
    $john->discard_changes;
    is($john->displayname, "John Suntrup", "User has in fact changed.");

    # When user is admin, can update any account
    $t = Test::Mojo->new('App::Agnes');
    $t->post_ok('/login' => form => {
        username => "mary",
        password => "pass1",
        tenant_id => $self->tenant_id(),
    }, "Login with admin account");
    ok($mary->is_admin);
    $t->put_ok("/api/rest/v1/account/" . $john->account_id => json => {
        account => {
            username    => "john",
            password    => "edmundpass1",
            displayname => "Buzz Suntrup",
            birthdate   => "2018-05-15",
            email       => 'ed@suntrup.net',
            account_type_id   => 4, # has_required_attrs
            attributes => {
                fav_book => "Goodnight Moon",
                christian_name => "Buzz",
                reception_date => "1990-01-01",
            },
        },
    })->status_is(200, "Can update other user's account with admin (and unprivileged) user.")
      ->json_hasnt('/err', "no error");
    $john->discard_changes;
    is($john->displayname, "Buzz Suntrup", "User has in fact changed.");
    is($john->attribute("christian_name"), "Buzz", "Attribute has been updated");

    $t->put_ok("/api/rest/v1/account/" . $john->account_id => json => {
        account => {
            username    => "john",
            password    => "edmundpass1",
            displayname => "Bingo Suntrup",
            birthdate   => "2018-05-15",
            email       => 'ed@suntrup.net',
            account_type_id   => 4, # has_required_attrs
            attributes => {
                fav_book => "Goodnight Moon",
                reception_date => "1990-01-01",
            },
        },
    })->status_is(400)
      ->json_is('/err', "EBADREQUEST", "Fails when attribute is missing");
    $john->discard_changes;
    is($john->displayname, "Buzz Suntrup", "User has not changed.");

    $t->put_ok("/api/rest/v1/account/" . $john->account_id => json => {
        account => {
            username    => "john",
            password    => "edmundpass1",
            displayname => "Bingo Suntrup",
            birthdate   => "2018-05-15",
            email       => 'ed@suntrup.net',
            account_type_id   => 4, # has_required_attrs
            attributes => {
                fav_book => "Goodnight Moon",
                christian_name => "Buzz",
                reception_date => "wrong type",
            },
        },
    })->status_is(400)
      ->json_is('/err', "EBADREQUEST", "Fails when attribute is wrong type");
    $john->discard_changes;
    is($john->displayname, "Buzz Suntrup", "User has not changed.");
}



# * read users
# 	* search for users by attribute
# 	* must be logged in


1;
