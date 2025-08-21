package Tests::App::Agnes::Controller::Space;

use strict;
use warnings;


use Tests::Utils::TestData;

use base 'Tests::Utils::CommonBase';
use Test::More;
use Test::Mojo;
use App::Agnes::Config;
use aliased 'App::Agnes::Model';
use Mojo::JSON qw/to_json/;

sub create_space : Tests {
    my $self = shift;
    my $t;

    # Summary:
    # 1.) create fails for non-admin with no privileges
    # 2.) create works for non-admin privileged user
    # 3.) creator is owner

    ###########################################################################
    ############ 1.) create fails for non-admin with no privileges ############
    ###########################################################################
    $t = Test::Mojo->new('App::Agnes');
    $t->post_ok('/login' => form => {
        username => "john",
        password => "pass3",
        tenant_id => $self->tenant_id(),
    })->status_is(302, "log in with unprivileged user");

    $t->post_ok('/api/rest/v1/spaces', json => {
        visibility => 'public',
        name => "John's Space",
    })->status_is(403)
      ->json_is('/err', 'ENOTAUTHORIZED', 'Not authorized to create top level space');

    ###########################################################################
    ############ 2.) create works for non-admin privileged user ###############
    ############ 3.) creator is owner                           ###############
    ###########################################################################
    $t = Test::Mojo->new('App::Agnes');
    my $joe = Model->rs('Account')->find({username => 'joe', tenant_id => $self->tenant_id });
    $t->post_ok('/login' => form => { # TODO: add privs for joe
        username => "joe",
        password => "pass2",
        tenant_id => $self->tenant_id(),
    })->status_is(302, "log in with unprivileged user");

    $t->post_ok('/api/rest/v1/spaces', json => {
        visibility => 'public',
        name => "Joe's Space",
    })->status_is(201)
      ->json_hasnt('/err')
      ->json_is('/res/space/visibility', 'public')
      ->json_is('/res/space/name', "Joe's Space")
      ->json_is('/res/space/owner_id', $joe->account_id, "Creator is also owner")
      ->json_has('/res/space/space_id')
      ->json_has('/res/space/icon')
      ->json_has('/res/space/subspaces');

    my $oid = Model->rs('Space')->search({ name => "Joe's Space"})->first->owner_id;
    is($oid, $joe->account_id, "Creator is also owner, but in database, not response.");

}

sub create_subspace : Tests {
    my $self = shift;
    my $t;
    my $parent = Model->rs('Space')->search({ name => 'top_level_demo_space' })->first;
    my $parent_id = $parent->space_id;
    my $parent_invisible = Model->rs('Space')->search({
        name => 'top_level_demo_space_invisible'
    })->first;
    my $parent_invisible_id = $parent_invisible->space_id;
    my $joe = Model->rs('Account')->find({username => 'joe', tenant_id => $self->tenant_id });

    # Summary:
    # 2.) create fails for parent space that doesn't exist and bad UUIDs
    # 4.) create works for non-admin privileged user
    # 1.) create fails for non-admin with no privileges
    # 3.) create does not give visibility information to any user even on fail
    #     As in, you get same error for attempting to create subspace with
    #     a parent that doesn't exist as a parent that is invisible to you

    ###########################################################################
    ############ 2.) create fails for parent space that doesn't exist #########
    ############     and for bad uuids                                #########
    ############ 4.) create works for non-admin privileged user       #########
    ###########################################################################
    $t = Test::Mojo->new('App::Agnes');
    $t->post_ok('/login' => form => { # TODO: add privs for joe
        username => "joe",
        password => "pass2",
        tenant_id => $self->tenant_id(),
    })->status_is(302, "log in with unprivileged user");

    $t->post_ok('/api/rest/v1/spaces', json => {
        visibility => 'public',
        name       => "Joe's Space",
        parent_id  => 'bcfcada6-31de-463c-a02d-b2a5673cea9f'
    })->status_is(404)
      ->json_hasnt('/res')
      ->json_is('/err', 'ENOMATCHINGID', "Fails for parent space that doesn't exist.");

    $t->post_ok('/api/rest/v1/spaces', json => {
        visibility => 'public',
        name       => "Joe's Space",
        parent_id  => 'nonsense-id-that-isnt-there',
    })->status_is(400, "Delete 400s for bad uuid")
      ->json_hasnt("/res")
      ->json_is("/err", 'EBADUUID', "Create fails for bad UUID");

    $t->post_ok('/api/rest/v1/spaces', json => {
        visibility => 'public',
        name => "Joe's Space",
        parent_id => $parent_id,
    })->status_is(201)
      ->json_hasnt('/err')
      ->json_is('/res/space/visibility', 'public')
      ->json_is('/res/space/name', "Joe's Space")
      ->json_is('/res/space/owner_id', $joe->account_id, "Creator is also owner")
      ->json_has('/res/space/space_id')
      ->json_has('/res/space/icon')
      ->json_has('/res/space/subspaces')
      ->json_is('/res/space/parent_id', $parent_id);

    ###########################################################################
    ############ 1.) create fails for non-admin with no privileges            #
    ############ 3.) create does not give visibility information to any user  #
    ############     even on fail. As in, you get same error for attempting   #
    ############     to create subspace with a parent that doesn't exist as a #
    ############     parent that is invisible to you                          #
    ###########################################################################
    # TODO: create top_level_demo_space, add john as member, but not with privs
    #       joe should own the space
    # TODO: create another space with joe as owner that john isn't added to, and
    #       does not have visibiliity of
    $t = Test::Mojo->new('App::Agnes');
    $t->post_ok('/login' => form => {
        username => "john",
        password => "pass3",
        tenant_id => $self->tenant_id(),
    })->status_is(302, "log in with unprivileged user");

    $t->post_ok('/api/rest/v1/spaces', json => {
        parent_id => $parent_id,
        visibility => 'public',
        name => "John's Space",
    })->status_is(403)
      ->json_is('/err', 'ENOTAUTORIZED', 'Not authorized to create subspace');

    $t->post_ok('/api/rest/v1/spaces', json => {
        parent_id => $parent_invisible_id,
        visibility => 'public',
        name => "John's Space",
    })->status_is(404)
      ->json_hasnt('/res')
      ->json_is('/err', 'ENOMATCHINGID', 'invisible spaces give same error as nonexistant ones');


}


1;

__END__

TODO: 
    * create
        * must have permission to create top level space (with no parent)
        * must have space permission (spermission? yuck) to create subspace
        * creator is owner
    * read
        * list spaces visible to me
            * all spaces of which I am a member are visible
            * all superspaces of all spaces of which I am a member are visible
            * all subspaces with visibility = visible of spaces of which I am a member are visible
            * all spaces I own and all of their subspaces regardless of visiblitiy are visible
            * all spaces I have space permissions to see are visible
            * all subspaces of spaces I have space permissions to see subspaces of are visible
            * admins can see all spaces
    * update
        * change owner
            * must be admin or owner or owner of superspace or have space permissions in current space or superspace
        * change name
            * must be admin or owner or owner of superspace or have space permissions in current space or superspace
        * change visibility
            * must be admin or owner or owner of superspace or have space permissions in current space or superspace
        * change parent
            * not supported. Delete it and create a new space.
    * delete
        * must be admin or owner or owner of superspace or have space permissions in current space or superspace
    * tables:
        * space_permissions
            * space_permission_id
            * permission (text)
                * can create subgroup
                * can change owner
                * can change name
                * can change visibility
                * can change parent
                * can post message
                * can delete other people's messages
                * can pin message
                * can add someone to space
                * can remove someone from space
                * can change someone's space role
                * can see the group?
                * can read message?
        * space_role_permissions
            space_roles <-> space_permissions
        * space_roles
            * role_name
                * space_admin (equal to owner)
                * member (read and post)
                * lurker (read)
                * chatter (space is a DM chat)
                * possbily more in the future, possibly admin-created
        * space_members
            * account_id, space_id, space_role_id
    * concepts:
        * each member of a space has exactly one role
        * each role has many permissions allowing a member to do different things
        * each space can have a subspace
        * subspaces are visible/invisible to members of the superspace based on perms and
          space settings
        * subspaces are also open to superspace members to join, or closed without invite
            * hence 4 types of subspaces, visibl/invisible X open/closed
