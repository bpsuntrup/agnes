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

Update schema:
make changes in database directly, then:
carmel exec -- bin/load_schema.pl

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

idea for GET /accounts query language:

just like lisp, but with JSON list syntax instead of s expressions.

boolean variable: b1, b2, ...
property:         a1, a2, ... (representing either a column on accounts or an account_attribute)
value :           v1, v2, ...

(and b1 b2 b3 ...)  -> boolean
(or b1 b2 b3 ...)   -> boolean
(not b1)            -> boolean
(in a1 (v1 v2 ...)) -> boolean
(is a1 v1)          -> boolean
(like a1 v1)        -> boolean
(starts_with a1 v1) -> boolean
(ends_with a1 v1)   -> boolean
(col v1)            -> property (accounts.v1, subject to validation)
(attr v1)           -> property (accounts->account_attributes->attributes, subject to valid.)
(prop type)         -> property (account_types.name)
"json string"       -> value


Full query:
{
    "where":
    [ "and",
        ["like", ["attr", "First Name"], "Ben"],
        ["is", ["prop", "type"], "catechumen"],
        ["or",
            ["is", ["prop", "space_member"], "Annunciation"],
            ["is", ["prop", "space_member"], "Assumption"],
        ]
    ],
}
Possibly, with optional other top level queries parameters next to "where" like:
* "page_size" (integer)
* "page"     (integer)
{
    "where": ["like", ["attr", "Last Name"], "Sun%"],
    "page": 1,
    "page_size": 50,
    "sort": [
        ["attr", "First Name"],
        ["col", "birthdate"],
    ],
}

These attributes should only be valid if:
They are real attributes in the database
They are public. I should add privacy settings and check those.
