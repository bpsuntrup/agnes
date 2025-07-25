use utf8;
package App::Agnes::Schema::Result::RolePermission;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'App::Agnes::DB::Result';
__PACKAGE__->load_components("InflateColumn::DateTime");
__PACKAGE__->table("role_permissions");
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
__PACKAGE__->set_primary_key("role_permission_id");
__PACKAGE__->belongs_to(
  "permission",
  "App::Agnes::Schema::Result::Permission",
  { permission_id => "permission_id" },
  { is_deferrable => 0, on_delete => "RESTRICT", on_update => "NO ACTION" },
);
__PACKAGE__->belongs_to(
  "role",
  "App::Agnes::Schema::Result::Role",
  { role_id => "role_id" },
  { is_deferrable => 0, on_delete => "RESTRICT", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07053 @ 2025-07-25 11:32:33
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:1+2n84VGSDuq2UYdAUdniw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
