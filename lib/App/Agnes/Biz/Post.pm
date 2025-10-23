package App::Agnes::Biz::Post;

use strict;
use warnings;

use base 'App::Agnes::Biz';
use aliased 'App::Agnes::Model';


sub get_posts {
    my $self = shift;
    my %params = @_;
    my $current_account = $params{current_account};

    my $posts = [ { body => 'This is the F1r$t p0&t' }, { body => 'This is second' } ];

    return BizResult->new(res => { posts => $posts } );
}

1;

__END__

=pod
=head1 NAME
App::Agnes::Biz::Post - CRUD method on Agnes Posts

=head1 SYNOPSIS

    use aliased 'App::Agnes::Biz::Post' => 'Biz'

    $res = Biz->get_posts(current_account => $ca);

    if ($res->err) {
        # Handle error, throw it or return HTTP code
    }
    my $posts = $res->res->{posts};
    ...

=head1 DESCRIPTION

Handles CRUD operations on posts

=head1 METHODS

=head2 get_posts

=cut
