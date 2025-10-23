=head1 generate_openapi3.pl

I don't like yaml anchors and stuff. I need more power for combining json schemas.

This programmatically builds an openapi3 spec for me. I can use loops and variables
and whatever else I want.

=cut

use JSON;

=head3 string, uuid, uri

Each of these subs takes one optional parameter for a description, and is basically
a string with a format given.

=cut

sub string {
    my $description = shift;
    return {
        type => "string",
        ($description ? (description => $description) : ()),
    };
}

sub uuid {
    my $schema = string(@_);
    $schema->{format} = "uuid";
    return $schema;
}

sub uri {
    my $schema = string(@_);
    $schema->{format} = "uri";
    return $schema;
}

sub account {
    return {
        type => "object",
        properties => {
            account_id => uuid(),
            name => string(),
            uri => uri(),
        }
    }
}

sub event {
    return {
        type => "object",
        properties => {
            event_id  => uuid(),
            datetime  => string(), # TODO: fix this
            account   => account(),
        },
    };
}


sub post {
    return {
        type => "object",
        properties => {
            post_id => uuid(),
            body    => string("Main text of the post"),
            uri     => uri(),
            created => event(),
            updated => event(),
            space   => string(), # TODO: write space(),
            reactions => {
                type => "array",
                items => {
                    type => "string", # TODO: make this betterer
                },
            },
            comments => {
                type => "array",
                items => string(), # TODO: make this better too
            },
        },
    };
}

=head3 sub res

Every response coming from Agnes is wrapped in a standard structure containing
a res, msg, and err attribute.

=cut

sub res {
    my $object_type = shift;
    my $schema = shift;
    my $ret = {
        type => "object",
        required => [ "res" ],
        properties => {
            res => {
                type => "object",
                required => [ $object_type ],
                properties => {
                    $object_type => $schema,
                }
            },
            msg => string("Optional return message with extra details"),
        },
    }

}

# TODO: should make this an array
sub list {
    return @_;
}

my %paths = (
    '/posts' => {
        get => {
            summary => 'Return all posts visible to user, paginated, ordered by date of most recent update, descending.',
            responses => {
                '200' => {
                    description => "OK",
                    content => {
                        'application/json' => {
                            schema => res("posts", list(post()))
                        },
                    },
                },
            },
        },
    },
);

my %spec = (
    openapi => "3.0.3",
    info => {
        title => "Agnes API",
        version => "1.0.0",
        description => "API for managing users, messages, spaces, attachments, and reports.",
    },
    servers => [
        { url => '/api/v1' },
    ],
    paths => \%paths,
);

print(JSON->new->pretty->encode(\%spec));

__END__
openapi: 3.0.3
info:
  title: Agnes API
  version: 1.0.0
  description: 

servers:
  - url: /api/v1

paths:
  /users:
    $ref: "./users/users.yaml"
  /posts:
    get: 
      summary: Return all posts visible to user, paginated, ordered by date of most recent update, descending.
      responses:
        200:
          description: OK
          content:
            application/json:
              schema:
                type: object
                required:
                  - post_id
                properties:
                  post_id:
                    type: string
                  body:
                    type: string
                  url:
                    type: string
                  created:
                    $ref: '#/components/schemas/Event'
                  updated:
                    $ref: '#/components/schemas/Event'
                  space:
                    type: object
                    properties:
                      space_id: string
                      url: string
                      name: string
                  reactions:
                    type: array
                    items:
                      type: string # This should have a link to the reaction and an ID that can be used in a cache
                  comments:
components:
  schemas:
    Event:
      type: object
      properties:
        event_id: string
        datetime:
          type: string
          format: date-time
        action_by:
          $ref: '#components/schemas/Account'
    Account:
      type: object
      properties:
        name: string
        account_id: string
        url: string




# let posts = [
#   {
#     post_id: 'gobbedy gook',
#     body: 'This is the body of the post. F!rst P0$T',
#     url: "/post/gobbedygook",
#     created: {
#       event_id: "more gook",
#       datetime: "5 October 2025 04:15:22 GMT",
#       action_by: {
#         name: "Fred Flintstone",
#         account_id: 'further gobbidy gook',
#         url: "/post/gobbedygook",
#         // more details about author
#       },
#     },
#     updated: undefined, // Also an event
#     space: {
#       space_id: "space gook",
#       url: "/space/gobbedygook",
#       name: "some space's name",
#     },
#     reactions: [
#       //TODO figure out what goes here
#     ],
#     comments: [
#       // theoretically, this is a list of posts with no comments
#       //                and no space
#     ]
#   },
# ];
