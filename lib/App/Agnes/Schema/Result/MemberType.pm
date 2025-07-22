use utf8;
package App::Agnes::Schema::Result::MemberType;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

App::Agnes::Schema::Result::MemberType

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<member_types>

=cut

__PACKAGE__->table("member_types");

=head1 ACCESSORS

=head2 member_type

  data_type: 'text'
  is_nullable: 0

=cut

__PACKAGE__->add_columns("member_type", { data_type => "text", is_nullable => 0 });

=head1 PRIMARY KEY

=over 4

=item * L</member_type>

=back

=cut

__PACKAGE__->set_primary_key("member_type");

=head1 RELATIONS

=head2 space_users

Type: has_many

Related object: L<App::Agnes::Schema::Result::SpaceUser>

=cut

__PACKAGE__->has_many(
  "space_users",
  "App::Agnes::Schema::Result::SpaceUser",
  { "foreign.member_type" => "self.member_type" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07053 @ 2025-07-21 20:54:50
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:fzxpEBeiaaELspIQxw3WYg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
