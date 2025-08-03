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

Schema design:
==============
# TODO



idea for GET /accounts query language:
======================================

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


Idea for API in general:
========================

Url:
/api/v1
/rest/v1
/rpc
/graphql
/api/rpc

REST JSON response layout:
    * Healthy response, "msg" is optional:
    {
        "res": {
            BODY OF METHOD RESPONSE GOES HERE
        },
        "msg": "Some optional msg string."
    }

    * Error response, "msg" also optional:
    {
        "err": "ERROR_CODE",
        "msg": "Optional description of error."
    }

Example of how "/accounts" resource is layed out:
    {
        "path": "/api/rest/v1/accounts/abig-uuid-iden-tify-ing-the-res-ource",
        "account_id":  "abig-uuid-iden-tify-ing-the-res-ource",
        "username": "fred2",
        "displayname": "Freddy L'Gauche",
        "birthdate": "1990-09-04",
        "email": "fred@lgauche.net",
        "account_type": "catechumen",
        "is_admin": false,
        "attributes": {
            "eye_color": "magenta",
            "reception_date": "2020-12-24"
        }
    }

    For CREATE, READ, UPDATE, the full record is returned.
    For DELETE, "res" is empty

GET request query parameters:
    fields=url,account_id
        * comma separated list of fields to return
    query=...
        * a string representing a query to run, based on query language described
          above

example:
GET /api/rest/v1/accounts?fields=url,account_id&query=%7B%22where%22:%5B%22and%22,%5B%22is%22,%5B%22attr%22,%22eye_color%22%5D,%22blue%22%5D,%5B%22is%22,%5B%22attr%22,%22sex%22%5D,%22male%22%5D%5D%7D
