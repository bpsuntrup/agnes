package App::Agnes::Controller::Main;

use strict;
use warnings;

use Mojo::Base 'Mojolicious::Controller';
#use aliased 'App::Blurble::Model';

# TODO: make differential response for content-type
sub index {
    my $self = shift;
    my $login_msg = $self->req->param('login_msg') || '';
    my $user_msg = $self->req->param('user_msg') || '';
    my $top_msg = $self->req->param('top_msg') || '';
    $self->render(template  => 'index',
                  login_msg => $login_msg, 
                  user_msg  => $user_msg,
                  top_msg   => $top_msg);
}

1;
