use utf8;
package App::Agnes::Schema::Result::Permission;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';
__PACKAGE__->load_components("InflateColumn::DateTime");
__PACKAGE__->table("permissions");
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
__PACKAGE__->set_primary_key("permission_id");
__PACKAGE__->has_many(
  "role_permissions",
  "App::Agnes::Schema::Result::RolePermission",
  { "foreign.permission_id" => "self.permission_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07053 @ 2025-07-25 14:46:00
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:zfo2MYLzsp37whQLgyCDpg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
