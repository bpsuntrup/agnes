use utf8;
package App::Agnes::Schema::Result::User;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

App::Agnes::Schema::Result::User

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<users>

=cut

__PACKAGE__->table("users");

=head1 ACCESSORS

=head2 user_id

  data_type: 'uuid'
  default_value: gen_random_uuid()
  is_nullable: 0
  retrieve_on_insert: 1
  size: 16

=head2 username

  data_type: 'text'
  is_nullable: 0

=head2 password

  data_type: 'text'
  is_nullable: 0

=head2 displayname

  data_type: 'text'
  is_nullable: 1

=head2 birthdate

  data_type: 'date'
  is_nullable: 1

=head2 email

  data_type: 'text'
  is_nullable: 1

=head2 user_type_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "user_id",
  {
    data_type => "uuid",
    default_value => \"gen_random_uuid()",
    is_nullable => 0,
    retrieve_on_insert => 1,
    size => 16,
  },
  "username",
  { data_type => "text", is_nullable => 0 },
  "password",
  { data_type => "text", is_nullable => 0 },
  "displayname",
  { data_type => "text", is_nullable => 1 },
  "birthdate",
  { data_type => "date", is_nullable => 1 },
  "email",
  { data_type => "text", is_nullable => 1 },
  "user_type_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</user_id>

=back

=cut

__PACKAGE__->set_primary_key("user_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<users_uk_username>

=over 4

=item * L</username>

=back

=cut

__PACKAGE__->add_unique_constraint("users_uk_username", ["username"]);

=head1 RELATIONS

=head2 files

Type: has_many

Related object: L<App::Agnes::Schema::Result::File>

=cut

__PACKAGE__->has_many(
  "files",
  "App::Agnes::Schema::Result::File",
  { "foreign.owner_id" => "self.user_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 posts

Type: has_many

Related object: L<App::Agnes::Schema::Result::Post>

=cut

__PACKAGE__->has_many(
  "posts",
  "App::Agnes::Schema::Result::Post",
  { "foreign.author_id" => "self.user_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 reactions

Type: has_many

Related object: L<App::Agnes::Schema::Result::Reaction>

=cut

__PACKAGE__->has_many(
  "reactions",
  "App::Agnes::Schema::Result::Reaction",
  { "foreign.user_id" => "self.user_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 space_users

Type: has_many

Related object: L<App::Agnes::Schema::Result::SpaceUser>

=cut

__PACKAGE__->has_many(
  "space_users",
  "App::Agnes::Schema::Result::SpaceUser",
  { "foreign.user_id" => "self.user_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 spaces

Type: has_many

Related object: L<App::Agnes::Schema::Result::Space>

=cut

__PACKAGE__->has_many(
  "spaces",
  "App::Agnes::Schema::Result::Space",
  { "foreign.owner_id" => "self.user_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 user_attributes

Type: has_many

Related object: L<App::Agnes::Schema::Result::UserAttribute>

=cut

__PACKAGE__->has_many(
  "user_attributes",
  "App::Agnes::Schema::Result::UserAttribute",
  { "foreign.user_id" => "self.user_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 user_roles

Type: has_many

Related object: L<App::Agnes::Schema::Result::UserRole>

=cut

__PACKAGE__->has_many(
  "user_roles",
  "App::Agnes::Schema::Result::UserRole",
  { "foreign.user_id" => "self.user_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 user_type

Type: belongs_to

Related object: L<App::Agnes::Schema::Result::UserType>

=cut

__PACKAGE__->belongs_to(
  "user_type",
  "App::Agnes::Schema::Result::UserType",
  { user_type_id => "user_type_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07053 @ 2025-07-22 07:29:54
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:l+EExJILUxEeEMnoblkIjQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
