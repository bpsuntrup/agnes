use utf8;
package App::Agnes::Schema::Result::Post;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';
__PACKAGE__->load_components("InflateColumn::DateTime");
__PACKAGE__->table("posts");
__PACKAGE__->add_columns(
  "post_id",
  {
    data_type => "uuid",
    default_value => \"gen_random_uuid()",
    is_nullable => 0,
    retrieve_on_insert => 1,
    size => 16,
  },
  "body",
  { data_type => "text", is_nullable => 1 },
  "author_id",
  { data_type => "uuid", is_foreign_key => 1, is_nullable => 0, size => 16 },
  "active",
  { data_type => "boolean", is_nullable => 0 },
  "space",
  { data_type => "uuid", is_foreign_key => 1, is_nullable => 0, size => 16 },
);
__PACKAGE__->set_primary_key("post_id");
__PACKAGE__->has_many(
  "attachments",
  "App::Agnes::Schema::Result::Attachment",
  { "foreign.post_id" => "self.post_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->belongs_to(
  "author",
  "App::Agnes::Schema::Result::User",
  { user_id => "author_id" },
  { is_deferrable => 0, on_delete => "RESTRICT", on_update => "NO ACTION" },
);
__PACKAGE__->has_many(
  "reactions",
  "App::Agnes::Schema::Result::Reaction",
  { "foreign.post_id" => "self.post_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->belongs_to(
  "space",
  "App::Agnes::Schema::Result::Space",
  { space_id => "space" },
  { is_deferrable => 0, on_delete => "RESTRICT", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07053 @ 2025-07-25 14:46:00
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:G32QBMHHxK9Z0dUVEKz50A


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
