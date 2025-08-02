use utf8;
package App::Agnes::Schema::Result::ReactionType;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';
__PACKAGE__->load_components("InflateColumn::DateTime");
__PACKAGE__->table("reaction_types");
__PACKAGE__->add_columns(
  "reaction_type_id",
  {
    data_type => "uuid",
    default_value => \"gen_random_uuid()",
    is_nullable => 0,
    retrieve_on_insert => 1,
    size => 16,
  },
  "name",
  { data_type => "text", is_nullable => 0 },
  "gif",
  { data_type => "bytea", is_nullable => 1 },
  "rank",
  { data_type => "integer", is_nullable => 1 },
  "unicode",
  { data_type => "text", is_nullable => 1 },
  "tenant_id",
  { data_type => "uuid", is_foreign_key => 1, is_nullable => 0, size => 16 },
);
__PACKAGE__->set_primary_key("reaction_type_id");
__PACKAGE__->add_unique_constraint("reaction_types_uk_name_tenant_id", ["name", "tenant_id"]);
__PACKAGE__->has_many(
  "reactions",
  "App::Agnes::Schema::Result::Reaction",
  { "foreign.reaction_type_id" => "self.reaction_type_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->belongs_to(
  "tenant",
  "App::Agnes::Schema::Result::Tenant",
  { tenant_id => "tenant_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07053 @ 2025-08-01 20:43:07
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:XYGpC8xq6BkQn5eC9OfeEw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
