use utf8;
package App::Agnes::Schema::Result::Permission;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

App::Agnes::Schema::Result::Permission

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<permissions>

=cut

__PACKAGE__->table("permissions");

=head1 ACCESSORS

=head2 permission_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'permissions_permission_id_seq'

=head2 permission

  data_type: 'text'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "permission_id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "permissions_permission_id_seq",
  },
  "permission",
  { data_type => "text", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</permission_id>

=back

=cut

__PACKAGE__->set_primary_key("permission_id");

=head1 RELATIONS

=head2 role_permissions

Type: has_many

Related object: L<App::Agnes::Schema::Result::RolePermission>

=cut

__PACKAGE__->has_many(
  "role_permissions",
  "App::Agnes::Schema::Result::RolePermission",
  { "foreign.permission_id" => "self.permission_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07053 @ 2025-07-22 07:29:54
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Kxb7wbx1Eol2ljRcu8++qQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
