use utf8;
package App::Agnes::Schema::Result::UserAttribute;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

App::Agnes::Schema::Result::UserAttribute

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<user_attributes>

=cut

__PACKAGE__->table("user_attributes");

=head1 ACCESSORS

=head2 user_id

  data_type: 'uuid'
  is_foreign_key: 1
  is_nullable: 0
  size: 16

=head2 value

  data_type: 'text'
  is_nullable: 0

=head2 user_attribute_type_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "user_id",
  { data_type => "uuid", is_foreign_key => 1, is_nullable => 0, size => 16 },
  "value",
  { data_type => "text", is_nullable => 0 },
  "user_attribute_type_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
);

=head1 RELATIONS

=head2 user

Type: belongs_to

Related object: L<App::Agnes::Schema::Result::User>

=cut

__PACKAGE__->belongs_to(
  "user",
  "App::Agnes::Schema::Result::User",
  { user_id => "user_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);

=head2 user_attribute_type

Type: belongs_to

Related object: L<App::Agnes::Schema::Result::Attribute>

=cut

__PACKAGE__->belongs_to(
  "user_attribute_type",
  "App::Agnes::Schema::Result::Attribute",
  { user_attribute_type_id => "user_attribute_type_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07053 @ 2025-07-22 07:29:54
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:q7AxoMvIPvqP1JlignZw3w


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
