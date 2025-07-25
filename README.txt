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

Validate documentation:
* see https://github.com/APIDevTools/swagger-cli
swagger-cli validate dox/openapi3/agnes.yaml

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
