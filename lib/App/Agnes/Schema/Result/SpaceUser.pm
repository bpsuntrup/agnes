use utf8;
package App::Agnes::Schema::Result::SpaceUser;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

App::Agnes::Schema::Result::SpaceUser

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<space_users>

=cut

__PACKAGE__->table("space_users");

=head1 ACCESSORS

=head2 space_user_id

  data_type: 'uuid'
  default_value: gen_random_uuid()
  is_nullable: 0
  retrieve_on_insert: 1
  size: 16

=head2 space_id

  data_type: 'uuid'
  is_foreign_key: 1
  is_nullable: 0
  size: 16

=head2 user_id

  data_type: 'uuid'
  is_foreign_key: 1
  is_nullable: 0
  size: 16

=head2 member_type

  data_type: 'text'
  default_value: 'member'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "space_user_id",
  {
    data_type => "uuid",
    default_value => \"gen_random_uuid()",
    is_nullable => 0,
    retrieve_on_insert => 1,
    size => 16,
  },
  "space_id",
  { data_type => "uuid", is_foreign_key => 1, is_nullable => 0, size => 16 },
  "user_id",
  { data_type => "uuid", is_foreign_key => 1, is_nullable => 0, size => 16 },
  "member_type",
  {
    data_type      => "text",
    default_value  => "member",
    is_foreign_key => 1,
    is_nullable    => 0,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</space_user_id>

=back

=cut

__PACKAGE__->set_primary_key("space_user_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<space_users_uk_space_id_user_id>

=over 4

=item * L</space_id>

=item * L</user_id>

=back

=cut

__PACKAGE__->add_unique_constraint("space_users_uk_space_id_user_id", ["space_id", "user_id"]);

=head1 RELATIONS

=head2 member_type

Type: belongs_to

Related object: L<App::Agnes::Schema::Result::MemberType>

=cut

__PACKAGE__->belongs_to(
  "member_type",
  "App::Agnes::Schema::Result::MemberType",
  { member_type => "member_type" },
  { is_deferrable => 0, on_delete => "RESTRICT", on_update => "NO ACTION" },
);

=head2 space

Type: belongs_to

Related object: L<App::Agnes::Schema::Result::Space>

=cut

__PACKAGE__->belongs_to(
  "space",
  "App::Agnes::Schema::Result::Space",
  { space_id => "space_id" },
  { is_deferrable => 0, on_delete => "RESTRICT", on_update => "NO ACTION" },
);

=head2 user

Type: belongs_to

Related object: L<App::Agnes::Schema::Result::User>

=cut

__PACKAGE__->belongs_to(
  "user",
  "App::Agnes::Schema::Result::User",
  { user_id => "user_id" },
  { is_deferrable => 0, on_delete => "RESTRICT", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07053 @ 2025-07-21 20:54:50
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:41tIDta7oj5gJpy9m9f+3g


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
