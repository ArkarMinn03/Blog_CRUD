<template>
  <nav class="navbar navbar-expand bg-body-tertiary">
    <div class="container">
      <router-link to="/blogs" class="navbar-brand">
        <h4>Bloggy</h4>
      </router-link>
      <ul v-if="isAuth" class="navbar-nav me-auto">
        <li class="nav-item">
          <router-link to="/blogs/new" class="nav-link">Create New Blog</router-link>
        </li>
        <li v-if="current_user.role_value < 3" class="nav-item">
          <router-link to="/admin" class="nav-link">Dashboard</router-link>
        </li>
      </ul>
      <div class="ms-auto">
        <div v-if="!isAuth">
          <router-link to="/login" class="btn btn-outline-dark me-2">Login</router-link>
          <router-link to="/signup" class="btn btn-dark">Signup</router-link>
        </div>
        <div v-else>
          <router-link v-if="current_user" to="/profile" class="btn me-2" :class="{
            'btn-success': current_user.role_value == 1,
            'btn-primary': current_user.role_value == 2,
            'btn-secondary': current_user.role_value == 3
          }">{{ current_user.name
            }}</router-link>
          <button class="btn btn-outline-danger" @click="logout">Logout</button>
        </div>
      </div>
    </div>
  </nav>
</template>

<script>
import blogService from '@/services/blogService'

export default {
  props: {
    isAuth: Boolean,
    current_user: Object
  },
  methods: {
    logout() {
      blogService.logout();

      localStorage.removeItem('access_token');
      this.$router.push({ name: 'Login' });
    }
  }
}
</script>