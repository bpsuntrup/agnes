use utf8;
package App::Agnes::Schema::Result::UserRole;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

App::Agnes::Schema::Result::UserRole

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<user_roles>

=cut

__PACKAGE__->table("user_roles");

=head1 ACCESSORS

=head2 user_role_id

  data_type: 'uuid'
  default_value: gen_random_uuid()
  is_nullable: 0
  retrieve_on_insert: 1
  size: 16

=head2 user_id

  data_type: 'uuid'
  is_foreign_key: 1
  is_nullable: 0
  size: 16

=head2 role_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "user_role_id",
  {
    data_type => "uuid",
    default_value => \"gen_random_uuid()",
    is_nullable => 0,
    retrieve_on_insert => 1,
    size => 16,
  },
  "user_id",
  { data_type => "uuid", is_foreign_key => 1, is_nullable => 0, size => 16 },
  "role_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</user_role_id>

=back

=cut

__PACKAGE__->set_primary_key("user_role_id");

=head1 RELATIONS

=head2 role

Type: belongs_to

Related object: L<App::Agnes::Schema::Result::Role>

=cut

__PACKAGE__->belongs_to(
  "role",
  "App::Agnes::Schema::Result::Role",
  { role_id => "role_id" },
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
  { is_deferrable => 0, on_delete => "CASCADE", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07053 @ 2025-07-22 07:29:54
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:rLC8Fakf5Blm07B+/MFeqA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
