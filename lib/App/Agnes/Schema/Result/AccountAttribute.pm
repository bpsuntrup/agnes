use utf8;
package App::Agnes::Schema::Result::AccountAttribute;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';
__PACKAGE__->load_components("InflateColumn::DateTime");
__PACKAGE__->table("account_attributes");
__PACKAGE__->add_columns(
  "account_id",
  { data_type => "uuid", is_foreign_key => 1, is_nullable => 0, size => 16 },
  "value",
  { data_type => "text", is_nullable => 0 },
  "attribute_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
);
__PACKAGE__->belongs_to(
  "account",
  "App::Agnes::Schema::Result::Account",
  { account_id => "account_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);
__PACKAGE__->belongs_to(
  "attribute",
  "App::Agnes::Schema::Result::Attribute",
  { attribute_id => "attribute_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07053 @ 2025-07-26 12:39:44
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:bNlfpeJPckX9Rru7YVCYmQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
