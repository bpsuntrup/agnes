use utf8;
package App::Agnes::Schema::Result::User;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';
__PACKAGE__->load_components("InflateColumn::DateTime");
__PACKAGE__->table("users");
__PACKAGE__->add_columns(
  "user_id",
  {
    data_type => "uuid",
    default_value => \"gen_random_uuid()",
    is_nullable => 0,
    retrieve_on_insert => 1,
    size => 16,
  },
  "username",
  { data_type => "text", is_nullable => 0 },
  "password",
  { data_type => "text", is_nullable => 0 },
  "displayname",
  { data_type => "text", is_nullable => 1 },
  "birthdate",
  { data_type => "date", is_nullable => 1 },
  "email",
  { data_type => "text", is_nullable => 1 },
  "user_type_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "is_admin",
  { data_type => "boolean", default_value => \"false", is_nullable => 0 },
);
__PACKAGE__->set_primary_key("user_id");
__PACKAGE__->add_unique_constraint("users_uk_username", ["username"]);
__PACKAGE__->has_many(
  "files",
  "App::Agnes::Schema::Result::File",
  { "foreign.owner_id" => "self.user_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->has_many(
  "posts",
  "App::Agnes::Schema::Result::Post",
  { "foreign.author_id" => "self.user_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->has_many(
  "reactions",
  "App::Agnes::Schema::Result::Reaction",
  { "foreign.user_id" => "self.user_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->has_many(
  "space_users",
  "App::Agnes::Schema::Result::SpaceUser",
  { "foreign.user_id" => "self.user_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->has_many(
  "spaces",
  "App::Agnes::Schema::Result::Space",
  { "foreign.owner_id" => "self.user_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->has_many(
  "user_attributes",
  "App::Agnes::Schema::Result::UserAttribute",
  { "foreign.user_id" => "self.user_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->has_many(
  "user_roles",
  "App::Agnes::Schema::Result::UserRole",
  { "foreign.user_id" => "self.user_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->belongs_to(
  "user_type",
  "App::Agnes::Schema::Result::UserType",
  { user_type_id => "user_type_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07053 @ 2025-07-25 14:46:00
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:0i60OmEig41jWn2ppFd7hg

use aliased 'App::Agnes::Model';
use DBI;

__PACKAGE__->many_to_many(roles => 'user_roles', 'role');

sub has_permission_old { 
    my ($self, $perm) = @_;
    return 1 if $self->is_admin;
    for my $role ($self->roles->all) {
        for my $permission ($role->permissions->all) {
            return 1 if $permission->permission eq $perm;
        }
    }
    return 0;
}

sub has_permission {
    my ($self, $perm) = @_;
    return 1 if $self->is_admin;

    return Model->rs('Permission')->search({
        'user.user_id' => $self->user_id,
        'me.permission' => $perm
    },{
        join => {
            role_permissions => {
                role => {
                    user_roles =>  'user',
                },
            },
        },
    })->count;
}

# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
