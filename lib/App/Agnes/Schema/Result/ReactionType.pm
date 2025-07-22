use utf8;
package App::Agnes::Schema::Result::ReactionType;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

App::Agnes::Schema::Result::ReactionType

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<reaction_types>

=cut

__PACKAGE__->table("reaction_types");

=head1 ACCESSORS

=head2 reaction_type_id

  data_type: 'uuid'
  default_value: gen_random_uuid()
  is_nullable: 0
  retrieve_on_insert: 1
  size: 16

=head2 name

  data_type: 'text'
  is_nullable: 0

=head2 gif

  data_type: 'bytea'
  is_nullable: 1

=head2 rank

  data_type: 'integer'
  is_nullable: 1

=head2 unicode

  data_type: 'text'
  is_nullable: 1

=cut

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

=head1 PRIMARY KEY

=over 4

=item * L</reaction_type_id>

=back

=cut

__PACKAGE__->set_primary_key("reaction_type_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<reaction_types_uk_name>

=over 4

=item * L</name>

=back

=cut

__PACKAGE__->add_unique_constraint("reaction_types_uk_name", ["name"]);

=head1 RELATIONS

=head2 reactions

Type: has_many

Related object: L<App::Agnes::Schema::Result::Reaction>

=cut

__PACKAGE__->has_many(
  "reactions",
  "App::Agnes::Schema::Result::Reaction",
  { "foreign.reaction_type_id" => "self.reaction_type_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07053 @ 2025-07-21 20:54:50
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:uwnqqwHzZvxN5Us8GFebdA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
