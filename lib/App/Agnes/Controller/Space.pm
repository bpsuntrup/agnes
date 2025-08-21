package App::Agnes::Controller::Space;

use strict;
use warnings;

use Mojo::Base 'Mojolicious::Controller';

use aliased 'App::Agnes::Biz::Space' => 'Biz';


# POST /spaces
sub create_space {
    my $c = shift;

    my $data = $c->req->json;

    my $res = Biz->create_space(space           => $data->{space},
                                current_account => $c->current_account);
    if ($res->err) {
        return $c->render_error(err => $res->err, msg => $res->msg);
    }

    return $c->render(json => { res => $res->res }, status => 201);
}

1;
