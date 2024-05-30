<template>
  <div class="container p-3" style="max-width: 800px">
    <h3>
      {{ blog_filter }} Blogs
      <div v-if="current_user_id" class="d-inline-block float-end">
        <select class="form-select form-select-sm" v-model="blog_filter">
          <option value="All">ALL</option>
          <option value="My">My Blogs</option>
        </select>
      </div>
    </h3>

    <div class="mt-3" v-for="blog in paginatedBlogs" :key="blog.id">
      <div class="card">
        <div class="card-body">
          <h5 class="card-title">
            {{ blog.title }}
            <div class="float-end">
              <p class="text-muted fs-6 fw-normal">
                <span>By: {{ blog.user.name }} ({{ timeAgo(blog.created_at) }})</span>
              </p>
            </div>
          </h5>

          <p class="card-text">{{ truncateContent(blog.content) }}</p>
          <RouterLink :to="`/blogs/${blog.id}`">More Details</RouterLink>
          <span class="text-muted fst-italic"> ( {{ blog.comment_count }} comments )</span>
        </div>
      </div>
    </div>
    <ul v-if="totalPages > 1" class="pagination mt-3 justify-content-center">
      <li class="page-item">
        <button class="page-link" @click="changePage(current_page - 1)" :disabled="current_page == 1">Prev</button>
      </li>
      <li class="page-item" v-for="pageNum in totalPages" :class="{ active: pageNum === current_page }">
        <button class="page-link" @click="changePage(pageNum)">{{ pageNum }}</button>
      </li>
      <li class="page-item">
        <button class="page-link" @click="changePage(current_page + 1)"
          :disabled="current_page == totalPages">Next</button>
      </li>
    </ul>
  </div>
</template>

<script>
import blogService from '@/services/blogService';
import { jwtDecode } from 'jwt-decode';
import moment from 'moment';


export default {
  data() {
    return {
      blogs: [],
      current_user_id: null,
      blog_filter: 'All',
      current_page: 1,
      blogsPerPage: 5,
      totalPages: null
    }
  },
  computed: {
    paginatedBlogs() {
      const start = (this.current_page - 1) * this.blogsPerPage;
      const end = start + this.blogsPerPage;

      return this.blogs.slice(start, end);
    }
  },
  methods: {
    async fetchBlogs() {
      const response = await blogService.getBlogs();
      this.blogs = response.data.blogs;

      if (this.blog_filter == "My") {
        this.blogs = this.blogs.filter(blog => blog.user.id == this.current_user_id)
        this.current_page = 1;
      }

      this.totalPages = Math.ceil(this.blogs.length / this.blogsPerPage)
    },
    changePage(page) {
      if (page < 1) {
        this.current_page = 1;
      }
      else if (page > this.totalPages) {
        this.current_page = totalPages;
      }
      else {
        this.current_page = page;
      }
    },
    truncateContent(content) {
      if (content.length > 80) {
        const truncatedContent = content.slice(0, 80)

        return truncatedContent + "  . . .";
      }

      return content;

    },
    timeAgo(date) {
      return moment(date).fromNow();
    }
  },
  watch: {
    blog_filter() {
      this.fetchBlogs();
    }
  },
  created() {
    const decodedToken = jwtDecode(localStorage.getItem('access_token'));
    this.current_user_id = decodedToken.user_id;

    this.fetchBlogs();
  }
}
</script>