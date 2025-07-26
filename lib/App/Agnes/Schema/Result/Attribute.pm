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
);
__PACKAGE__->set_primary_key("attribute_id");
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


# Created by DBIx::Class::Schema::Loader v0.07053 @ 2025-07-26 12:39:44
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:jFW3SeyKBKEUfzG9XvuT/Q


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
