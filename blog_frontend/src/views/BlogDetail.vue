<template>
  <div class="container my-3" style="max-width: 800px;">
    <div v-if="blog.user" class="card">
      <div class="card-body">
        <h3 class="card-title">
          {{ blog.title }}
          <div v-if="current_user_id == blog.user.id" class="float-end">
            <router-link class="btn btn-sm btn-outline-secondary me-2" :to="`/blogs/${blog.id}/edit`">Edit</router-link>
            <button class="btn btn-sm btn-outline-danger" @click="deleteBlog(blog.id)">Delete</button>
          </div>
        </h3>
        <div>
          <p class="text-muted">
            <span class="fst-italic">Posted by - {{ blog.user.name }}, </span>
            <span class="fst-italic">{{ timeAgo(blog.created_at) }}</span>
          </p>
          <p class="card-body">{{ blog.content }}</p>
        </div>
      </div>
    </div>
    <div class="mt-3">
      <ul class="list-group my-3">
        <li class="list-group-item active">Comments</li>
        <li v-for="comment in comments" :key="comment.id" class="list-group-item py-3">
          <b>{{ comment.user.name }} <span class="fst-italic fw-normal">( {{ timeAgo(comment.created_at) }} )</span>
          </b><br>&nbsp;&nbsp;-
          {{ comment.comment }}
          <div class="float-end">
            <button v-if="current_user_id == comment.user.id" class="btn btn-sm btn-secondary me-2"
              @click="editComment(comment.id)">Edit</button>
            <button v-if="current_user_id == comment.user.id || current_user_id == blog.user.id"
              class="btn btn-sm btn-danger" @click="deleteComment(comment.id)">delete</button>
          </div>
        </li>
        <li class="list-group-item py-3">
          <form v-if="!isEditing" @submit.prevent="createComment">
            <div class="input-group">
              <input type="text" class="form-control" v-model="commentText">
              <button class="btn btn-primary" type="submit">Comment</button>
            </div>
          </form>
          <form v-else @submit.prevent="updateComment">
            <div class="input-group">
              <input type="text" class="form-control" v-model="commentText">
              <button class="btn btn-primary" type="submit">Update</button>
            </div>
          </form>
        </li>
      </ul>
    </div>
  </div>
</template>

<script>
import blogService from '@/services/blogService';
import { jwtDecode } from 'jwt-decode';
import moment from 'moment';

export default {
  data() {
    return {
      blog: {},
      comments: {},
      commentText: '',
      editingCommentID: null,
      current_user_id: '',
      isEditing: false,
      blogID: this.$route.params.id,
    }
  },
  methods: {
    async fetchBlogDetail() {
      const response = await blogService.getBlog(this.$route.params.id);
      this.blog = response.data.blog;
    },
    async deleteBlog(blog_id) {
      await blogService.deleteBlog(blog_id);
      this.$router.push('/blogs');
      // blogService.getBlogs();
    },
    async fetchComments() {
      const response = await blogService.getComments(this.$route.params.id);
      this.comments = response.data.comment;
    },
    async deleteComment(comment_id) {
      await blogService.deleteComment(this.$route.params.id, comment_id);
      // this.$router.push(`/blogs/${this.$route.params.id}`);
      this.comments = this.comments.filter(comment => comment.id !== comment_id)
    },
    async createComment() {
      const comment = {
        comment: this.commentText,
        user_id: this.current_user_id
      };
      await blogService.createComment(this.$route.params.id, comment);
      this.fetchComments();
      this.commentText = '';
    },
    async getUserName(user_id) {
      const response = await blogService.getUser(user_id);
      const user = response.data;

      return user.name;
    },
    async editComment(comment_id) {
      const response = await blogService.getComment(this.$route.params.id, comment_id);
      this.commentText = response.data.comment;
      this.editingCommentID = response.data.id;
      this.isEditing = !this.isEditing;
    },
    async updateComment() {
      const comment = {
        comment: this.commentText,
        user_id: this.current_user_id
      };
      await blogService.updateComment(this.blogID, this.editingCommentID, comment);

      const index = this.comments.findIndex(comment => comment.id === this.editingCommentID);

      if (index !== -1) {
        this.comments[index].comment = this.commentText
      }

      //resetting commentText, editing comment id and editing stage
      this.commentText = '';
      this.editingCommentID = null;
      this.isEditing = !this.isEditing;
    },
    timeAgo(date) {
      return moment(date).fromNow();
    }
  },
  mounted() {
    const decodedToken = jwtDecode(localStorage.getItem('access_token'))
    this.current_user_id = decodedToken.user_id

    this.fetchBlogDetail();
    this.fetchComments();
  }
}
</script>