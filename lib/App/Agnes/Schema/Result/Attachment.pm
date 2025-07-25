use utf8;
package App::Agnes::Schema::Result::Attachment;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'App::Agnes::DB::Result';
__PACKAGE__->load_components("InflateColumn::DateTime");
__PACKAGE__->table("attachments");
__PACKAGE__->add_columns(
  "attachment_id",
  {
    data_type => "uuid",
    default_value => \"gen_random_uuid()",
    is_nullable => 0,
    retrieve_on_insert => 1,
    size => 16,
  },
  "post_id",
  { data_type => "uuid", is_foreign_key => 1, is_nullable => 0, size => 16 },
  "file_id",
  { data_type => "uuid", is_foreign_key => 1, is_nullable => 0, size => 16 },
);
__PACKAGE__->set_primary_key("attachment_id");
__PACKAGE__->add_unique_constraint("attachments_uk_post_id_file_id", ["post_id", "file_id"]);
__PACKAGE__->belongs_to(
  "file",
  "App::Agnes::Schema::Result::File",
  { file_id => "file_id" },
  { is_deferrable => 0, on_delete => "CASCADE", on_update => "NO ACTION" },
);
__PACKAGE__->belongs_to(
  "post",
  "App::Agnes::Schema::Result::Post",
  { post_id => "post_id" },
  { is_deferrable => 0, on_delete => "CASCADE", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07053 @ 2025-07-25 11:32:33
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:mThShX4gVetaoUVxTo29ig


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
