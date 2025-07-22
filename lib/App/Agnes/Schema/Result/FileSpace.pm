use utf8;
package App::Agnes::Schema::Result::FileSpace;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

App::Agnes::Schema::Result::FileSpace

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<file_spaces>

=cut

__PACKAGE__->table("file_spaces");

=head1 ACCESSORS

=head2 file_space_id

  data_type: 'uuid'
  default_value: gen_random_uuid()
  is_nullable: 0
  retrieve_on_insert: 1
  size: 16

=head2 file_id

  data_type: 'uuid'
  is_foreign_key: 1
  is_nullable: 0
  size: 16

=head2 space_id

  data_type: 'uuid'
  is_foreign_key: 1
  is_nullable: 0
  size: 16

=cut

__PACKAGE__->add_columns(
  "file_space_id",
  {
    data_type => "uuid",
    default_value => \"gen_random_uuid()",
    is_nullable => 0,
    retrieve_on_insert => 1,
    size => 16,
  },
  "file_id",
  { data_type => "uuid", is_foreign_key => 1, is_nullable => 0, size => 16 },
  "space_id",
  { data_type => "uuid", is_foreign_key => 1, is_nullable => 0, size => 16 },
);

=head1 PRIMARY KEY

=over 4

=item * L</file_space_id>

=back

=cut

__PACKAGE__->set_primary_key("file_space_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<file_spaces_uk_file_id_space_id>

=over 4

=item * L</file_id>

=item * L</space_id>

=back

=cut

__PACKAGE__->add_unique_constraint("file_spaces_uk_file_id_space_id", ["file_id", "space_id"]);

=head1 RELATIONS

=head2 file

Type: belongs_to

Related object: L<App::Agnes::Schema::Result::File>

=cut

__PACKAGE__->belongs_to(
  "file",
  "App::Agnes::Schema::Result::File",
  { file_id => "file_id" },
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


# Created by DBIx::Class::Schema::Loader v0.07053 @ 2025-07-21 20:54:50
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:X2MzXzHJyeOJ1ShUSdLkaA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
