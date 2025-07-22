use utf8;
package App::Agnes::Schema::Result::Space;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

App::Agnes::Schema::Result::Space

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<spaces>

=cut

__PACKAGE__->table("spaces");

=head1 ACCESSORS

=head2 space_id

  data_type: 'uuid'
  default_value: gen_random_uuid()
  is_nullable: 0
  retrieve_on_insert: 1
  size: 16

=head2 visibility

  data_type: 'enum'
  extra: {custom_type_name => "visibility",list => ["private","public"]}
  is_nullable: 0

=head2 name

  data_type: 'text'
  is_nullable: 0

=head2 icon

  data_type: 'uuid'
  is_foreign_key: 1
  is_nullable: 1
  size: 16

=head2 owner_id

  data_type: 'uuid'
  is_foreign_key: 1
  is_nullable: 0
  size: 16

=cut

__PACKAGE__->add_columns(
  "space_id",
  {
    data_type => "uuid",
    default_value => \"gen_random_uuid()",
    is_nullable => 0,
    retrieve_on_insert => 1,
    size => 16,
  },
  "visibility",
  {
    data_type => "enum",
    extra => { custom_type_name => "visibility", list => ["private", "public"] },
    is_nullable => 0,
  },
  "name",
  { data_type => "text", is_nullable => 0 },
  "icon",
  { data_type => "uuid", is_foreign_key => 1, is_nullable => 1, size => 16 },
  "owner_id",
  { data_type => "uuid", is_foreign_key => 1, is_nullable => 0, size => 16 },
);

=head1 PRIMARY KEY

=over 4

=item * L</space_id>

=back

=cut

__PACKAGE__->set_primary_key("space_id");

=head1 RELATIONS

=head2 file_spaces

Type: has_many

Related object: L<App::Agnes::Schema::Result::FileSpace>

=cut

__PACKAGE__->has_many(
  "file_spaces",
  "App::Agnes::Schema::Result::FileSpace",
  { "foreign.space_id" => "self.space_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 icon

Type: belongs_to

Related object: L<App::Agnes::Schema::Result::File>

=cut

__PACKAGE__->belongs_to(
  "icon",
  "App::Agnes::Schema::Result::File",
  { file_id => "icon" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
);

=head2 owner

Type: belongs_to

Related object: L<App::Agnes::Schema::Result::User>

=cut

__PACKAGE__->belongs_to(
  "owner",
  "App::Agnes::Schema::Result::User",
  { user_id => "owner_id" },
  { is_deferrable => 0, on_delete => "RESTRICT", on_update => "NO ACTION" },
);

=head2 posts

Type: has_many

Related object: L<App::Agnes::Schema::Result::Post>

=cut

__PACKAGE__->has_many(
  "posts",
  "App::Agnes::Schema::Result::Post",
  { "foreign.space" => "self.space_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 space_users

Type: has_many

Related object: L<App::Agnes::Schema::Result::SpaceUser>

=cut

__PACKAGE__->has_many(
  "space_users",
  "App::Agnes::Schema::Result::SpaceUser",
  { "foreign.space_id" => "self.space_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07053 @ 2025-07-21 20:54:50
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:90D7BCD8p88UHNf8JiQ8tw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
