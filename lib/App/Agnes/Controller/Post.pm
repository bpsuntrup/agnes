package App::Agnes::Controller::Post;

use strict;
use warnings;

use Mojo::Base 'Mojolicious::Controller';

use aliased 'App::Agnes::Biz::Post' => 'Biz ';

# GET /posts
# TODO: paginate the hayek out of this
sub get_accounts {
    my $c = shift;

    my $res = Biz->get_posts(current_account => $c->current_account);
    if ($res->err) {
        return $c->render_error(err => $res->err, msg => $res->msg);
    }

    return $c->render(json => { res => $res->res }, status => 200);
}

1;
