<template>
  <div class="container mt-3 p-3" style="max-width: 600px">
    <h3 class="text-center">Signup Here</h3>
    <form class="mt-3" @submit.prevent="signup">
      <input type="text" class="form-control mb-3" v-model="name" placeholder="Name" required>
      <input type="email" class="form-control mb-3" v-model="email" placeholder="Email" required>
      <input type="password" class="form-control mb-3" v-model="password" placeholder="Password" required>
      <input type="password" class="form-control mb-3" v-model="passwordConfirmation" placeholder="Confirm Password"
        required>
      <button class="btn btn-primary mx-auto" type="submit">Signup</button>
    </form>
  </div>
</template>

<script>
import blogService from '@/services/blogService'

export default {
  data() {
    return {
      name: '',
      email: '',
      password: '',
      passwordConfirmation: '',
      role_value: 3
    }
  },
  methods: {
    async signup() {
      try {
        await blogService.signup({
          "user": {
            name: this.name,
            email: this.email,
            password: this.password,
            password_confirmation: this.passwordConfirmation,
            role_value: this.role_value
          }
        });
        this.$router.push({ name: 'Login' });
      } catch (error) {
        console.error('Failed to signup: ', error);
      }
    }
  }
}
</script>