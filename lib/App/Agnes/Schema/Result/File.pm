use utf8;
package App::Agnes::Schema::Result::File;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';
__PACKAGE__->load_components("InflateColumn::DateTime");
__PACKAGE__->table("files");
__PACKAGE__->add_columns(
  "file_id",
  {
    data_type => "uuid",
    default_value => \"gen_random_uuid()",
    is_nullable => 0,
    retrieve_on_insert => 1,
    size => 16,
  },
  "url",
  { data_type => "text", is_nullable => 0 },
  "mimetype",
  { data_type => "text", is_nullable => 1 },
  "owner_id",
  { data_type => "uuid", is_foreign_key => 1, is_nullable => 0, size => 16 },
  "public",
  { data_type => "boolean", default_value => \"false", is_nullable => 0 },
  "name",
  { data_type => "text", is_nullable => 1 },
  "tenant_id",
  { data_type => "uuid", is_foreign_key => 1, is_nullable => 0, size => 16 },
);
__PACKAGE__->set_primary_key("file_id");
__PACKAGE__->has_many(
  "attachments",
  "App::Agnes::Schema::Result::Attachment",
  { "foreign.file_id" => "self.file_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->has_many(
  "file_spaces",
  "App::Agnes::Schema::Result::FileSpace",
  { "foreign.file_id" => "self.file_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->belongs_to(
  "owner",
  "App::Agnes::Schema::Result::Account",
  { account_id => "owner_id" },
  { is_deferrable => 0, on_delete => "RESTRICT", on_update => "NO ACTION" },
);
__PACKAGE__->has_many(
  "spaces",
  "App::Agnes::Schema::Result::Space",
  { "foreign.icon" => "self.file_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->belongs_to(
  "tenant",
  "App::Agnes::Schema::Result::Tenant",
  { tenant_id => "tenant_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07053 @ 2025-08-01 20:43:07
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:hEjJeZHczsxrwGuTAJWk/g


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
