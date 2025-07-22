use utf8;
package App::Agnes::Schema::Result::Reaction;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

App::Agnes::Schema::Result::Reaction

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<reactions>

=cut

__PACKAGE__->table("reactions");

=head1 ACCESSORS

=head2 reaction_id

  data_type: 'uuid'
  default_value: gen_random_uuid()
  is_nullable: 0
  retrieve_on_insert: 1
  size: 16

=head2 post_id

  data_type: 'uuid'
  is_foreign_key: 1
  is_nullable: 0
  size: 16

=head2 user_id

  data_type: 'uuid'
  is_foreign_key: 1
  is_nullable: 0
  size: 16

=head2 reaction_type_id

  data_type: 'uuid'
  is_foreign_key: 1
  is_nullable: 0
  size: 16

=cut

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
  "user_id",
  { data_type => "uuid", is_foreign_key => 1, is_nullable => 0, size => 16 },
  "reaction_type_id",
  { data_type => "uuid", is_foreign_key => 1, is_nullable => 0, size => 16 },
);

=head1 PRIMARY KEY

=over 4

=item * L</reaction_id>

=back

=cut

__PACKAGE__->set_primary_key("reaction_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<reactions_uk_post_id_user_id_reaction_type_id>

=over 4

=item * L</post_id>

=item * L</user_id>

=item * L</reaction_type_id>

=back

=cut

__PACKAGE__->add_unique_constraint(
  "reactions_uk_post_id_user_id_reaction_type_id",
  ["post_id", "user_id", "reaction_type_id"],
);

=head1 RELATIONS

=head2 post

Type: belongs_to

Related object: L<App::Agnes::Schema::Result::Post>

=cut

__PACKAGE__->belongs_to(
  "post",
  "App::Agnes::Schema::Result::Post",
  { post_id => "post_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);

=head2 reaction_type

Type: belongs_to

Related object: L<App::Agnes::Schema::Result::ReactionType>

=cut

__PACKAGE__->belongs_to(
  "reaction_type",
  "App::Agnes::Schema::Result::ReactionType",
  { reaction_type_id => "reaction_type_id" },
  { is_deferrable => 0, on_delete => "RESTRICT", on_update => "NO ACTION" },
);

=head2 user

Type: belongs_to

Related object: L<App::Agnes::Schema::Result::User>

=cut

__PACKAGE__->belongs_to(
  "user",
  "App::Agnes::Schema::Result::User",
  { user_id => "user_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07053 @ 2025-07-21 20:54:50
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:5yslsv9y0Q7QeLoIyvSNNA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
