use utf8;
package App::Agnes::Schema::Result::UserAttribute;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';
__PACKAGE__->load_components("InflateColumn::DateTime");
__PACKAGE__->table("user_attributes");
__PACKAGE__->add_columns(
  "user_id",
  { data_type => "uuid", is_foreign_key => 1, is_nullable => 0, size => 16 },
  "value",
  { data_type => "text", is_nullable => 0 },
  "user_attribute_type_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
);
__PACKAGE__->belongs_to(
  "user",
  "App::Agnes::Schema::Result::User",
  { user_id => "user_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);
__PACKAGE__->belongs_to(
  "user_attribute_type",
  "App::Agnes::Schema::Result::Attribute",
  { user_attribute_type_id => "user_attribute_type_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07053 @ 2025-07-25 14:46:00
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:QvMTErLAmArJc2+thKQEeA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
