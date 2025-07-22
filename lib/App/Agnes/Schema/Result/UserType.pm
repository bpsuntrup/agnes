use utf8;
package App::Agnes::Schema::Result::UserType;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

App::Agnes::Schema::Result::UserType

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<user_types>

=cut

__PACKAGE__->table("user_types");

=head1 ACCESSORS

=head2 user_type_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'user_types_user_type_id_seq'

=head2 name

  data_type: 'text'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "user_type_id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "user_types_user_type_id_seq",
  },
  "name",
  { data_type => "text", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</user_type_id>

=back

=cut

__PACKAGE__->set_primary_key("user_type_id");

=head1 RELATIONS

=head2 user_type_attributes

Type: has_many

Related object: L<App::Agnes::Schema::Result::UserTypeAttribute>

=cut

__PACKAGE__->has_many(
  "user_type_attributes",
  "App::Agnes::Schema::Result::UserTypeAttribute",
  { "foreign.user_type_id" => "self.user_type_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 users

Type: has_many

Related object: L<App::Agnes::Schema::Result::User>

=cut

__PACKAGE__->has_many(
  "users",
  "App::Agnes::Schema::Result::User",
  { "foreign.user_type_id" => "self.user_type_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07053 @ 2025-07-21 20:54:50
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:rILy9ouYjzBcHAnn6WMtXQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
