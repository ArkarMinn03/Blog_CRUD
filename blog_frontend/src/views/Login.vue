<template>
  <div class="container mt-3 p-3" style="max-width: 600px;">
    <h3 class="text-center">Login Here</h3>
    <div v-if="errMessage" class="alert alert-warning text-center my-3">
      {{ errMessage }}
    </div>
    <form @submit.prevent="login">
      <input class="form-control mb-3" type="email" v-model="email" placeholder="Email">
      <input class="form-control mb-3" type="password" v-model="password" placeholder="Password">
      <button class="btn btn-primary mx-auto">Login</button>
    </form>
  </div>
</template>

<script>
import blogService from '@/services/blogService';
// import jwtDecode from 'jwt-decode';

export default {
  data() {
    return {
      email: '',
      password: '',
      errMessage: null
    }
  },
  methods: {
    async login() {
      try {
        const credentials = {
          email: this.email,
          password: this.password
        }
        const response = await blogService.login(credentials);
        localStorage.setItem('access_token', response.data.access);
        // this.decodeJWT = jwtDecode(response.data.access);
        this.$router.push({ name: 'BlogList' });
      } catch (error) {
        if (error.response) {
          this.errMessage = error.response.data.errMsg;
        }
      }
    }
  }
}
</script>