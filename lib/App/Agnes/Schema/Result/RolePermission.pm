use utf8;
package App::Agnes::Schema::Result::RolePermission;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

App::Agnes::Schema::Result::RolePermission

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<role_permissions>

=cut

__PACKAGE__->table("role_permissions");

=head1 ACCESSORS

=head2 role_permission_id

  data_type: 'uuid'
  default_value: gen_random_uuid()
  is_nullable: 0
  retrieve_on_insert: 1
  size: 16

=head2 role_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 permission_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "role_permission_id",
  {
    data_type => "uuid",
    default_value => \"gen_random_uuid()",
    is_nullable => 0,
    retrieve_on_insert => 1,
    size => 16,
  },
  "role_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "permission_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</role_permission_id>

=back

=cut

__PACKAGE__->set_primary_key("role_permission_id");

=head1 RELATIONS

=head2 permission

Type: belongs_to

Related object: L<App::Agnes::Schema::Result::Permission>

=cut

__PACKAGE__->belongs_to(
  "permission",
  "App::Agnes::Schema::Result::Permission",
  { permission_id => "permission_id" },
  { is_deferrable => 0, on_delete => "RESTRICT", on_update => "NO ACTION" },
);

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


# Created by DBIx::Class::Schema::Loader v0.07053 @ 2025-07-22 07:29:54
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Pj6CnnE0WjKr/xIkE6tt9Q


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
