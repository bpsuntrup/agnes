use utf8;
package App::Agnes::Schema::Result::Attachment;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

App::Agnes::Schema::Result::Attachment

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<attachments>

=cut

__PACKAGE__->table("attachments");

=head1 ACCESSORS

=head2 attachment_id

  data_type: 'uuid'
  default_value: gen_random_uuid()
  is_nullable: 0
  retrieve_on_insert: 1
  size: 16

=head2 post_id

  data_type: 'uuid'
  is_foreign_key: 1
  is_nullable: 0
  size: 16

=head2 file_id

  data_type: 'uuid'
  is_foreign_key: 1
  is_nullable: 0
  size: 16

=cut

__PACKAGE__->add_columns(
  "attachment_id",
  {
    data_type => "uuid",
    default_value => \"gen_random_uuid()",
    is_nullable => 0,
    retrieve_on_insert => 1,
    size => 16,
  },
  "post_id",
  { data_type => "uuid", is_foreign_key => 1, is_nullable => 0, size => 16 },
  "file_id",
  { data_type => "uuid", is_foreign_key => 1, is_nullable => 0, size => 16 },
);

=head1 PRIMARY KEY

=over 4

=item * L</attachment_id>

=back

=cut

__PACKAGE__->set_primary_key("attachment_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<attachments_uk_post_id_file_id>

=over 4

=item * L</post_id>

=item * L</file_id>

=back

=cut

__PACKAGE__->add_unique_constraint("attachments_uk_post_id_file_id", ["post_id", "file_id"]);

=head1 RELATIONS

=head2 file

Type: belongs_to

Related object: L<App::Agnes::Schema::Result::File>

=cut

__PACKAGE__->belongs_to(
  "file",
  "App::Agnes::Schema::Result::File",
  { file_id => "file_id" },
  { is_deferrable => 0, on_delete => "CASCADE", on_update => "NO ACTION" },
);

=head2 post

Type: belongs_to

Related object: L<App::Agnes::Schema::Result::Post>

=cut

__PACKAGE__->belongs_to(
  "post",
  "App::Agnes::Schema::Result::Post",
  { post_id => "post_id" },
  { is_deferrable => 0, on_delete => "CASCADE", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07053 @ 2025-07-21 20:54:50
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Tgg7rPHNbqKA5gOjitN6uQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
