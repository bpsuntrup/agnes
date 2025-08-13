use utf8;
package App::Agnes::Schema::Result::Account;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';
__PACKAGE__->load_components("InflateColumn::DateTime");
__PACKAGE__->table("accounts");
__PACKAGE__->add_columns(
  "account_id",
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
  "account_type_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "is_admin",
  { data_type => "boolean", default_value => \"false", is_nullable => 0 },
  "tenant_id",
  { data_type => "uuid", is_foreign_key => 1, is_nullable => 0, size => 16 },
  "is_active",
  { data_type => "boolean", default_value => \"true", is_nullable => 0 },
);
__PACKAGE__->set_primary_key("account_id");
__PACKAGE__->add_unique_constraint("accounts_uk_username_tenant_id", ["username", "tenant_id"]);
__PACKAGE__->has_many(
  "account_attributes",
  "App::Agnes::Schema::Result::AccountAttribute",
  { "foreign.account_id" => "self.account_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->has_many(
  "account_roles",
  "App::Agnes::Schema::Result::AccountRole",
  { "foreign.account_id" => "self.account_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->belongs_to(
  "account_type",
  "App::Agnes::Schema::Result::AccountType",
  { account_type_id => "account_type_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);
__PACKAGE__->has_many(
  "files",
  "App::Agnes::Schema::Result::File",
  { "foreign.owner_id" => "self.account_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->has_many(
  "posts",
  "App::Agnes::Schema::Result::Post",
  { "foreign.author_id" => "self.account_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->has_many(
  "reactions",
  "App::Agnes::Schema::Result::Reaction",
  { "foreign.account_id" => "self.account_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->has_many(
  "space_accounts",
  "App::Agnes::Schema::Result::SpaceAccount",
  { "foreign.account_id" => "self.account_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->has_many(
  "spaces",
  "App::Agnes::Schema::Result::Space",
  { "foreign.owner_id" => "self.account_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->belongs_to(
  "tenant",
  "App::Agnes::Schema::Result::Tenant",
  { tenant_id => "tenant_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07053 @ 2025-08-03 20:19:36
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:RzykFJUBrtOOZw93fmmVpg

use aliased 'App::Agnes::Model';
use DBI;

__PACKAGE__->many_to_many(roles => 'account_roles', 'role');
__PACKAGE__->resultset_class('App::Agnes::Schema::ResultSet::Accounts');

sub attribute {
    my $self = shift;
    my $att_name = shift;
    return $self->account_attributes->find({'attribute.name' => $att_name},{ join => 'attribute' })->value;
}

sub attributes {
    my $self = shift;
    my %atts = ();
    my @account_attributes = $self->account_attributes->search({},{ join => 'attribute' })->all;
    for my $att (@account_attributes) {
        $atts{$att->attribute->name} = $att->value;
    }
    return \%atts;
}

sub permissions_rs {
    my $self = shift;
    return Model->rs('Permission')->search({
        'account.account_id' => $self->account_id,
    },{
        join => {
            role_permissions => {
                role => {
                    account_roles =>  'account',
                },
            },
        },
    });
}

sub has_permission {
    my ($self, $perm) = @_;
    return 1 if $self->is_admin;
    return $self->permissions_rs->count;
}

# adapter for possibly other ways of determining activity in future
sub active {
    my $self = shift;
    return $self->is_active;
}

# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
