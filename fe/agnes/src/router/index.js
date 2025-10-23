import { createRouter, createWebHistory } from 'vue-router'

import Feed from '../components/Feed.vue'
import Profile from '../components/Profile.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    { path: "/", component: Feed},
    { path: "/profile", component: Profile},
  ],
})

export default router
