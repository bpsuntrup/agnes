use utf8;
package App::Agnes::Schema::Result::File;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

App::Agnes::Schema::Result::File

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<files>

=cut

__PACKAGE__->table("files");

=head1 ACCESSORS

=head2 file_id

  data_type: 'uuid'
  default_value: gen_random_uuid()
  is_nullable: 0
  retrieve_on_insert: 1
  size: 16

=head2 url

  data_type: 'text'
  is_nullable: 0

=head2 mimetype

  data_type: 'text'
  is_nullable: 1

=head2 owner_id

  data_type: 'uuid'
  is_foreign_key: 1
  is_nullable: 0
  size: 16

=head2 public

  data_type: 'boolean'
  default_value: false
  is_nullable: 0

=head2 name

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "file_id",
  {
    data_type => "uuid",
    default_value => \"gen_random_uuid()",
    is_nullable => 0,
    retrieve_on_insert => 1,
    size => 16,
  },
  "url",
  { data_type => "text", is_nullable => 0 },
  "mimetype",
  { data_type => "text", is_nullable => 1 },
  "owner_id",
  { data_type => "uuid", is_foreign_key => 1, is_nullable => 0, size => 16 },
  "public",
  { data_type => "boolean", default_value => \"false", is_nullable => 0 },
  "name",
  { data_type => "text", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</file_id>

=back

=cut

__PACKAGE__->set_primary_key("file_id");

=head1 RELATIONS

=head2 attachments

Type: has_many

Related object: L<App::Agnes::Schema::Result::Attachment>

=cut

__PACKAGE__->has_many(
  "attachments",
  "App::Agnes::Schema::Result::Attachment",
  { "foreign.file_id" => "self.file_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 file_spaces

Type: has_many

Related object: L<App::Agnes::Schema::Result::FileSpace>

=cut

__PACKAGE__->has_many(
  "file_spaces",
  "App::Agnes::Schema::Result::FileSpace",
  { "foreign.file_id" => "self.file_id" },
  { cascade_copy => 0, cascade_delete => 0 },
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

=head2 spaces

Type: has_many

Related object: L<App::Agnes::Schema::Result::Space>

=cut

__PACKAGE__->has_many(
  "spaces",
  "App::Agnes::Schema::Result::Space",
  { "foreign.icon" => "self.file_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07053 @ 2025-07-21 20:54:50
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:UyReWNV8gaBZYJyLnxuJVw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
