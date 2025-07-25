use utf8;
package App::Agnes::Schema::Result::UserTypeAttribute;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';
__PACKAGE__->load_components("InflateColumn::DateTime");
__PACKAGE__->table("user_type_attributes");
__PACKAGE__->add_columns(
  "user_type_attribute_id",
  {
    data_type => "uuid",
    default_value => \"gen_random_uuid()",
    is_nullable => 0,
    retrieve_on_insert => 1,
    size => 16,
  },
  "user_type_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "required",
  { data_type => "boolean", is_nullable => 0 },
);
__PACKAGE__->set_primary_key("user_type_attribute_id");
__PACKAGE__->belongs_to(
  "user_type",
  "App::Agnes::Schema::Result::UserType",
  { user_type_id => "user_type_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07053 @ 2025-07-25 14:46:00
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:np9mSr5WDar/QTzWfIJZUA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
