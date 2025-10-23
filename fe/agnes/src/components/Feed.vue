<script setup>

// Get posts:
let posts = [
  {
    post_id: 'gobbedy gook',
    body: 'This is the body of the post. F!rst P0$T',
    url: "/post/gobbedygook",
    created: {
      event_id: "more gook",
      datetime: "5 October 2025 04:15:22 GMT",
      action_by: {
        name: "Fred Flintstone",
        account_id: 'further gobbidy gook',
        url: "/post/gobbedygook",
        // more details about author
      },
    },
    updated: undefined, // Also an event
    space: {
      space_id: "space gook",
      url: "/space/gobbedygook",
      name: "some space's name",
    },
    reactions: [
      //TODO figure out what goes here
    ],
    comments: [
      // theoretically, this is a list of posts with no comments
      //                and no space
    ]
  },
];

</script>

<template>
  <h1>This is feed</h1>
  <ul>
    <li v-for="post in posts">
      {{ post.body }}
    </li>
  </ul>
</template>

<style scoped></style>
