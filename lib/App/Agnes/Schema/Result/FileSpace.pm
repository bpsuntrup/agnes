use utf8;
package App::Agnes::Schema::Result::FileSpace;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';
__PACKAGE__->load_components("InflateColumn::DateTime");
__PACKAGE__->table("file_spaces");
__PACKAGE__->add_columns(
  "file_space_id",
  {
    data_type => "uuid",
    default_value => \"gen_random_uuid()",
    is_nullable => 0,
    retrieve_on_insert => 1,
    size => 16,
  },
  "file_id",
  { data_type => "uuid", is_foreign_key => 1, is_nullable => 0, size => 16 },
  "space_id",
  { data_type => "uuid", is_foreign_key => 1, is_nullable => 0, size => 16 },
);
__PACKAGE__->set_primary_key("file_space_id");
__PACKAGE__->add_unique_constraint("file_spaces_uk_file_id_space_id", ["file_id", "space_id"]);
__PACKAGE__->belongs_to(
  "file",
  "App::Agnes::Schema::Result::File",
  { file_id => "file_id" },
  { is_deferrable => 0, on_delete => "RESTRICT", on_update => "NO ACTION" },
);
__PACKAGE__->belongs_to(
  "space",
  "App::Agnes::Schema::Result::Space",
  { space_id => "space_id" },
  { is_deferrable => 0, on_delete => "RESTRICT", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07053 @ 2025-07-25 14:46:00
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:n//5T6RFft4RcuKCEEXecg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
