<template>
  <div class="container mt-3" style="max-width: 800px;">
    <h1>Edit blog</h1>
    <form @submit.prevent="updateBlog">
      <div class="my-3">
        <label for="title" class="form-label">Title : </label>
        <input class="form-control" id="title" v-model="title" required>
      </div>
      <div class="mb-3">
        <label class="form-label" for="content">Content: </label>
        <textarea class="form-control" id="content" v-model="content" required rows="10"></textarea>
      </div>
      <button type="submit" class="btn btn-primary">Update</button>
    </form>
  </div>
</template>

<script>
import blogService from '@/services/blogService'

export default {
  data() {
    return {
      title: '',
      content: '',
      blogID: this.$route.params.id
    }
  },
  methods: {
    async fetchBlogData() {
      const response = await blogService.getBlog(this.blogID);
      this.title = response.data.blog.title;
      this.content = response.data.blog.content;
    },
    async updateBlog() {
      const blog = {
        title: this.title,
        content: this.content
      }
      await blogService.updateBlog(this.blogID, blog);
      this.$router.push(`/blogs/${this.blogID}`);
    }
  },
  mounted() {
    this.fetchBlogData();
  }
}
</script>