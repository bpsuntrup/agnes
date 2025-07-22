use utf8;
package App::Agnes::Schema::Result::Post;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

App::Agnes::Schema::Result::Post

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<posts>

=cut

__PACKAGE__->table("posts");

=head1 ACCESSORS

=head2 post_id

  data_type: 'uuid'
  default_value: gen_random_uuid()
  is_nullable: 0
  retrieve_on_insert: 1
  size: 16

=head2 body

  data_type: 'text'
  is_nullable: 1

=head2 author_id

  data_type: 'uuid'
  is_foreign_key: 1
  is_nullable: 0
  size: 16

=head2 active

  data_type: 'boolean'
  is_nullable: 0

=head2 space

  data_type: 'uuid'
  is_foreign_key: 1
  is_nullable: 0
  size: 16

=cut

__PACKAGE__->add_columns(
  "post_id",
  {
    data_type => "uuid",
    default_value => \"gen_random_uuid()",
    is_nullable => 0,
    retrieve_on_insert => 1,
    size => 16,
  },
  "body",
  { data_type => "text", is_nullable => 1 },
  "author_id",
  { data_type => "uuid", is_foreign_key => 1, is_nullable => 0, size => 16 },
  "active",
  { data_type => "boolean", is_nullable => 0 },
  "space",
  { data_type => "uuid", is_foreign_key => 1, is_nullable => 0, size => 16 },
);

=head1 PRIMARY KEY

=over 4

=item * L</post_id>

=back

=cut

__PACKAGE__->set_primary_key("post_id");

=head1 RELATIONS

=head2 attachments

Type: has_many

Related object: L<App::Agnes::Schema::Result::Attachment>

=cut

__PACKAGE__->has_many(
  "attachments",
  "App::Agnes::Schema::Result::Attachment",
  { "foreign.post_id" => "self.post_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 author

Type: belongs_to

Related object: L<App::Agnes::Schema::Result::User>

=cut

__PACKAGE__->belongs_to(
  "author",
  "App::Agnes::Schema::Result::User",
  { user_id => "author_id" },
  { is_deferrable => 0, on_delete => "RESTRICT", on_update => "NO ACTION" },
);

=head2 reactions

Type: has_many

Related object: L<App::Agnes::Schema::Result::Reaction>

=cut

__PACKAGE__->has_many(
  "reactions",
  "App::Agnes::Schema::Result::Reaction",
  { "foreign.post_id" => "self.post_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 space

Type: belongs_to

Related object: L<App::Agnes::Schema::Result::Space>

=cut

__PACKAGE__->belongs_to(
  "space",
  "App::Agnes::Schema::Result::Space",
  { space_id => "space" },
  { is_deferrable => 0, on_delete => "RESTRICT", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07053 @ 2025-07-21 20:54:50
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:0No8UgYEjsgvRD/UYUYlOg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
