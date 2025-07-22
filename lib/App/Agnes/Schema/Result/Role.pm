use utf8;
package App::Agnes::Schema::Result::Role;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

App::Agnes::Schema::Result::Role

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<roles>

=cut

__PACKAGE__->table("roles");

=head1 ACCESSORS

=head2 role_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'roles_role_id_seq'

=head2 name

  data_type: 'text'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "role_id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "roles_role_id_seq",
  },
  "name",
  { data_type => "text", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</role_id>

=back

=cut

__PACKAGE__->set_primary_key("role_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<roles_name_key>

=over 4

=item * L</name>

=back

=cut

__PACKAGE__->add_unique_constraint("roles_name_key", ["name"]);

=head1 RELATIONS

=head2 role_permissions

Type: has_many

Related object: L<App::Agnes::Schema::Result::RolePermission>

=cut

__PACKAGE__->has_many(
  "role_permissions",
  "App::Agnes::Schema::Result::RolePermission",
  { "foreign.role_id" => "self.role_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 user_roles

Type: has_many

Related object: L<App::Agnes::Schema::Result::UserRole>

=cut

__PACKAGE__->has_many(
  "user_roles",
  "App::Agnes::Schema::Result::UserRole",
  { "foreign.role_id" => "self.role_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07053 @ 2025-07-22 07:29:54
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:fIgLA+n8L6Yo6k+2zBRDxw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
