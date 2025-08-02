use utf8;
package App::Agnes::Schema::Result::Role;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';
__PACKAGE__->load_components("InflateColumn::DateTime");
__PACKAGE__->table("roles");
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
  "tenant_id",
  { data_type => "uuid", is_foreign_key => 1, is_nullable => 0, size => 16 },
);
__PACKAGE__->set_primary_key("role_id");
__PACKAGE__->add_unique_constraint("roles_uk_name_tenant_id", ["name", "tenant_id"]);
__PACKAGE__->has_many(
  "account_roles",
  "App::Agnes::Schema::Result::AccountRole",
  { "foreign.role_id" => "self.role_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->has_many(
  "role_permissions",
  "App::Agnes::Schema::Result::RolePermission",
  { "foreign.role_id" => "self.role_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->belongs_to(
  "tenant",
  "App::Agnes::Schema::Result::Tenant",
  { tenant_id => "tenant_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07053 @ 2025-08-01 20:43:07
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:0KggDIFs4RU7cC7jjAx63w

__PACKAGE__->many_to_many(permissions => 'role_permissions', 'permission');

# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
