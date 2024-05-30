<template>
  <div class="container mt-3" style="max-width: 800px;">
    <h1>Create new blog</h1>
    <form @submit.prevent="createBlog">
      <div class="my-3">
        <label for="title" class="form-label">Title : </label>
        <input class="form-control" id="title" v-model="title" required>
      </div>
      <div class="mb-3">
        <label class="form-label" for="content">Content: </label>
        <textarea class="form-control" id="content" v-model="content" required rows="10"></textarea>
      </div>
      <button type="submit" class="btn btn-primary">Create</button>
    </form>
  </div>
</template>

<script>
import blogService from '@/services/blogService'
import { jwtDecode } from 'jwt-decode';

export default {
  data() {
    return {
      title: '',
      content: '',
      user_id: ''
    }
  },
  methods: {
    async createBlog() {
      const blog = {
        title: this.title,
        content: this.content,
        user_id: this.user_id
      };
      await blogService.createBlog(blog);
      this.$router.push('/blogs');
    }
  },
  mounted() {
    const decodedToken = jwtDecode(localStorage.getItem('access_token'))
    this.user_id = decodedToken.user_id
  }
}
</script>