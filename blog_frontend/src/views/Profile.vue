<template>
  <div class="container mt-5" style="max-width: 800px;">
    <h3 class="text-center">User Profile</h3>
    <div v-if="message" class="alert alert-info">
      {{ message }}
    </div>
    <div v-if="error_msg" class="alert alert-warning">
      {{ error_msg }}
    </div>
    <div class="row mt-5">
      <div class="col-6 bg-light rounded-3 p-3">
        <div>
          <form @submit.prevent="updateUser">
            <div class="mb-3">
              <div class="d-inline-block">
                <label class="form-label" for="name">ID : {{ id }}</label>
              </div>
            </div>
            <div class="mb-3">
              <label class="form-label" for="name">Name : </label>
              <input class="form-control" type="text" id="name" v-model="name" :disabled="!isEditing">
            </div>
            <div class="mb-4">
              <label class="form-label" for="email">Email : </label>
              <input class="form-control" type="email" id="email" v-model="email" :disabled="!isEditing">
            </div>
            <div class="mb-2 d-flex justify-content-center">
              <button v-if="!isEditing" type="button" class="btn btn-danger me-2" @click="deleteUser">Delete</button>
              <button v-else type="button" class="btn btn-secondary me-2"
                @click="isEditing = !isEditing">Cancel</button>
              <button v-if="!isEditing" type="button" class="btn btn-primary"
                @click="isEditing = !isEditing">Edit</button>
              <button v-else type="submit" class="btn btn-success">Update</button>
            </div>
          </form>
        </div>
      </div>
      <div class="col-6 p-3">
        <h6 class="text-danger mb-4">Change Password</h6>
        <form @submit.prevent="changePassword">
          <div class="mb-3">
            <input type="password" class="form-control" placeholder="New Password" v-model="new_password">
          </div>
          <div class="mb-3">
            <input type="password" class="form-control" placeholder="Confirm New Password"
              v-model="confirm_new_password">
          </div>
          <div class="mb-3">
            <input type="password" class="form-control" placeholder="Current Password" v-model="old_password">
          </div>
          <div class="mb-3">
            <button class="btn btn-danger float-end">Change</button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script>
import blogService from '@/services/blogService';
import { jwtDecode } from 'jwt-decode';

export default {
  data() {
    return {
      id: null,
      name: '',
      email: '',
      isEditing: false,
      message: '',
      error_msg: '',
      old_password: '',
      new_password: '',
      confirm_new_password: '',
    }
  },
  methods: {
    async fetchUser(id) {
      const response = await blogService.getUser(id)
      this.id = response.data.id
      this.name = response.data.name
      this.email = response.data.email
    },
    async updateUser() {
      const user = {
        name: this.name,
        email: this.email
      }
      const response = await blogService.updateUser(this.id, user);
      this.message = response.data.message;
    },
    async deleteUser() {
      if (confirm('You sure you not gonna regret this?')) {
        const response = await blogService.deleteUser(this.id);

        blogService.logout();
        localStorage.removeItem('access_token');
        this.$router.push({ name: 'Login' });
      }
    },
    async changePassword() {
      if (confirm("You are changing your password. You know that right?")) {
        const pass = {
          old_password: this.old_password,
          password: this.new_password,
          confirm_password: this.confirm_new_password
        };
        const response = await blogService.updatePassword(this.id, pass);
        this.message = response.data.message;
        this.error_msg = response.data.error;

        //resetting the password fields
        this.new_password = '';
        this.old_password = '';
        this.confirm_new_password = '';
      }
    }
  },
  mounted() {
    const decodedToken = jwtDecode(localStorage.getItem('access_token'))
    this.fetchUser(decodedToken.user_id)
  }
}
</script>