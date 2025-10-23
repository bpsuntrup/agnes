<script setup>
import Feed from './components/Feed.vue'
import Profile from './components/Profile.vue'
</script>


<template>
  <h1>You did it!</h1>
  <p>
    Visit <a href="https://vuejs.org/" target="_blank" rel="noopener">vuejs.org</a> to read the
    documentation
  </p>
  <main>
    <RouterView />
  </main>
  <nav>
    <RouterLink to="/"> Feed </RouterLink>
    <RouterLink to="/profile"> Profile </RouterLink>
  </nav>
</template>

<style scoped></style>
