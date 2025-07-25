use utf8;
package App::Agnes::Schema::Result::MemberType;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'App::Agnes::DB::Result';
__PACKAGE__->load_components("InflateColumn::DateTime");
__PACKAGE__->table("member_types");
__PACKAGE__->add_columns("member_type", { data_type => "text", is_nullable => 0 });
__PACKAGE__->set_primary_key("member_type");
__PACKAGE__->has_many(
  "space_users",
  "App::Agnes::Schema::Result::SpaceUser",
  { "foreign.member_type" => "self.member_type" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07053 @ 2025-07-25 11:32:33
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:0xdL7gd8xP8RbPt7gfLnyw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
