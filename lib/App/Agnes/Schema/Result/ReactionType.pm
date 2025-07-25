use utf8;
package App::Agnes::Schema::Result::ReactionType;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'App::Agnes::DB::Result';
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
);
__PACKAGE__->set_primary_key("reaction_type_id");
__PACKAGE__->add_unique_constraint("reaction_types_uk_name", ["name"]);
__PACKAGE__->has_many(
  "reactions",
  "App::Agnes::Schema::Result::Reaction",
  { "foreign.reaction_type_id" => "self.reaction_type_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07053 @ 2025-07-25 11:32:33
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Y73Acez+yqX82noAZaTofA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
