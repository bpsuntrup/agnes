use utf8;
package App::Agnes::Schema::Result::Reaction;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';
__PACKAGE__->load_components("InflateColumn::DateTime");
__PACKAGE__->table("reactions");
__PACKAGE__->add_columns(
  "reaction_id",
  {
    data_type => "uuid",
    default_value => \"gen_random_uuid()",
    is_nullable => 0,
    retrieve_on_insert => 1,
    size => 16,
  },
  "post_id",
  { data_type => "uuid", is_foreign_key => 1, is_nullable => 0, size => 16 },
  "account_id",
  { data_type => "uuid", is_foreign_key => 1, is_nullable => 0, size => 16 },
  "reaction_type_id",
  { data_type => "uuid", is_foreign_key => 1, is_nullable => 0, size => 16 },
);
__PACKAGE__->set_primary_key("reaction_id");
__PACKAGE__->add_unique_constraint(
  "reactions_uk_post_id_user_id_reaction_type_id",
  ["post_id", "account_id", "reaction_type_id"],
);
__PACKAGE__->belongs_to(
  "account",
  "App::Agnes::Schema::Result::Account",
  { account_id => "account_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);
__PACKAGE__->belongs_to(
  "post",
  "App::Agnes::Schema::Result::Post",
  { post_id => "post_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);
__PACKAGE__->belongs_to(
  "reaction_type",
  "App::Agnes::Schema::Result::ReactionType",
  { reaction_type_id => "reaction_type_id" },
  { is_deferrable => 0, on_delete => "RESTRICT", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07053 @ 2025-07-26 12:39:44
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:9bvnPI+xmjFgQrjt0CU6jQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
