agnes is a social media clone written for fun and for father joel.

The admin interface is available only to the user 'agnes'. Other admin users can
be added through the admin login interface /agnes

Install:
cd App-Agnes
carmel install

Run:
carmel exec -- morbo bin/app

Run tests:
carmel exec -- prove -lv t/xUnit.t


TODO:
* google calendar integration
* users should have customizable attributes that differe for different user
  types
  * user type table
  * user role table (groups of permissions)
  * user permission table (create new groups, create subgroups, invite people
    to app, invite people to groups, etc.)
  * user attributes table
* files should be stored in s3 or something.
* admin dashboard
* posts should only go n levels deep
* spaces should be able to subscribe to RSS feed

The database data files are ~/pgdata, which is postgres 15. 


/api/v1/...
The api will be built around the following resources:
/users
/messages
/spaces
/attachments

want to 
* crud a message
* crud a user
* crud a space
* crd an attachment

GET /spaces
* lists all spaces (you can see, public and private)
* filter with query params

GET /messages
* lists all messages you can see in reverse chronological order, paged
* filter for public or private

GET /spaces/<space-id>/messages
* get messages only for a given space

POST /spaces/<space-id>/messages
* send a message

GET /users
* paginated list of users

GET /users?query="..."
GET /users/<user-id>
GET /users/<user-id>/messages
GET /space/<space-id>/users
PUT /messages/<message-id>
* for editing a message

POST /messages/<message-id>/reactions
* adding a reaction

GET/POST/DELETE /attachments/<attachment_id>
* no method for listing all attachments
* controlled by session cookie and permissions in attachments table (and attachment_owner_spaces)
* only the owner can delete
* only owner or spaces can see
* served via fs on back end. Must be hardened to fs walking attacks. Check permissions before serving file.

POST /reports
* creates a report for a message or a conversation or something

messages
* HAS body
* HAS MANY spaces (can be IM, posted to group, to individual's wall, as subcomment on another comment)
* HAS author
* HAS MANY reactions
* HAS MANY attachments

attachments
* HAS A (single) owner
* HAS MANY owner_spaces (where this is visible)
* url
* mime type

spaces
* HAS MANY messages
* HAS MANY participants (space_participants)
* enum(public/private)
* name
* icon


space_participants
* mapping table between users and spaces

reactions
* HAS A message
* HAS A author (users)
* HAS A reaction type
* unique across all three of these columns
* all three are required

reaction_type
* HAS A small gif

users need types. (child/adult, faithful/catechumen/inquirer/priest/deacon)

user_type
* many to many,  user_attribute_types

user_attribute_types
* name
* type (date, text, enum, int, boolean)
* many to many user_types

user_type_attributes_types
* maps between user types and user attribute types
* user_type
* user_attribute_type
* required boolean

user_attributes
* user
* user_attribute_type
* value

user

            List of relations
 Schema |     Name     | Type  |  Owner
--------+--------------+-------+----------
 public | file_spaces  | table | benjamin # galleries, i guess. I don't like this. will leave it out for now.
 public | files        | table | benjamin #restrict on mime type for now, and only allow jpg, gif
 public | member_types | table | benjamin # used by space memberships to distinguish between admin and member (could probably be a bool)
 public | space_users  | table | benjamin # space memberships
 public | attachments  | table | benjamin # relates posts to files, main key to driving file availability
 public | user_types   | table | benjamin # priest, faithful, inquirer, etc
 public | posts        | table | benjamin \
 public | spaces       | table | benjamin  )-- the three main tables running the app
 public | users        | table | benjamin /
