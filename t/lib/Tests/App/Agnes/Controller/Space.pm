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
    ok(1, "running test");
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
