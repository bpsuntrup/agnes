use utf8;
package App::Agnes::Schema::Result::Attribute;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

App::Agnes::Schema::Result::Attribute

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<attributes>

=cut

__PACKAGE__->table("attributes");

=head1 ACCESSORS

=head2 name

  data_type: 'text'
  is_nullable: 0

=head2 type

  data_type: 'text'
  is_nullable: 0

=head2 user_attribute_type_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'user_attribute_types_user_attribute_type_id_seq'

=cut

__PACKAGE__->add_columns(
  "name",
  { data_type => "text", is_nullable => 0 },
  "type",
  { data_type => "text", is_nullable => 0 },
  "user_attribute_type_id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "user_attribute_types_user_attribute_type_id_seq",
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</user_attribute_type_id>

=back

=cut

__PACKAGE__->set_primary_key("user_attribute_type_id");

=head1 RELATIONS

=head2 user_attributes

Type: has_many

Related object: L<App::Agnes::Schema::Result::UserAttribute>

=cut

__PACKAGE__->has_many(
  "user_attributes",
  "App::Agnes::Schema::Result::UserAttribute",
  {
    "foreign.user_attribute_type_id" => "self.user_attribute_type_id",
  },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07053 @ 2025-07-22 07:29:54
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:zzjkO5Vnl8rp+UsMvgDDIA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
