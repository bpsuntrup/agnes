use utf8;
package App::Agnes::Schema::Result::Attribute;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';
__PACKAGE__->load_components("InflateColumn::DateTime");
__PACKAGE__->table("attributes");
__PACKAGE__->add_columns(
  "name",
  { data_type => "text", is_nullable => 0 },
  "type",
  { data_type => "text", is_nullable => 0 },
  "attribute_id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "user_attribute_types_user_attribute_type_id_seq",
  },
  "tenant_id",
  { data_type => "uuid", is_foreign_key => 1, is_nullable => 0, size => 16 },
);
__PACKAGE__->set_primary_key("attribute_id");
__PACKAGE__->add_unique_constraint("attributes_uk_name_tenant_id", ["name", "tenant_id"]);
__PACKAGE__->has_many(
  "account_attributes",
  "App::Agnes::Schema::Result::AccountAttribute",
  { "foreign.attribute_id" => "self.attribute_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->has_many(
  "account_type_attributes",
  "App::Agnes::Schema::Result::AccountTypeAttribute",
  { "foreign.attribute_id" => "self.attribute_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->belongs_to(
  "tenant",
  "App::Agnes::Schema::Result::Tenant",
  { tenant_id => "tenant_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07053 @ 2025-08-01 20:50:37
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:calzPEg5f5t0uRJNiAZ6Bg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
