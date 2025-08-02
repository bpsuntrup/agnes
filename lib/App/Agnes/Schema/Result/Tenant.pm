use utf8;
package App::Agnes::Schema::Result::Tenant;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';
__PACKAGE__->load_components("InflateColumn::DateTime");
__PACKAGE__->table("tenants");
__PACKAGE__->add_columns(
  "tenant_id",
  {
    data_type => "uuid",
    default_value => \"gen_random_uuid()",
    is_nullable => 0,
    retrieve_on_insert => 1,
    size => 16,
  },
  "name",
  { data_type => "text", is_nullable => 0 },
);
__PACKAGE__->set_primary_key("tenant_id");
__PACKAGE__->add_unique_constraint("tenants_name_key", ["name"]);
__PACKAGE__->has_many(
  "account_types",
  "App::Agnes::Schema::Result::AccountType",
  { "foreign.tenant_id" => "self.tenant_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->has_many(
  "accounts",
  "App::Agnes::Schema::Result::Account",
  { "foreign.tenant_id" => "self.tenant_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->has_many(
  "files",
  "App::Agnes::Schema::Result::File",
  { "foreign.tenant_id" => "self.tenant_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->has_many(
  "reaction_types",
  "App::Agnes::Schema::Result::ReactionType",
  { "foreign.tenant_id" => "self.tenant_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->has_many(
  "roles",
  "App::Agnes::Schema::Result::Role",
  { "foreign.tenant_id" => "self.tenant_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->has_many(
  "spaces",
  "App::Agnes::Schema::Result::Space",
  { "foreign.tenant_id" => "self.tenant_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07053 @ 2025-08-01 20:43:07
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:v+MohJZN029bDH1hz1fY8g


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
