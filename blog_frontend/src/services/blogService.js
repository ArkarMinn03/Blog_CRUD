import apiClient from "./api";

export default {
  getBlogs() {
    return apiClient.get('/blogs');
  },
  getBlog(id) {
    return apiClient.get(`/blogs/${id}`);
  },
  createBlog(blog){
    return apiClient.post('/blogs', blog);
  },
  updateBlog(id, blog){
    return apiClient.put(`/blogs/${id}`, blog);
  },
  deleteBlog(id) {
    return apiClient.delete(`/blogs/${id}`);
  },
  login(credentials) {
    return apiClient.post('/login', credentials);
  },
  signup(user) {
    return apiClient.post('/users', user);
  },
  logout() {
    return apiClient.delete('/logout');
  },
  refresh() {
    return apiClient.post('/refresh');
  },
  updateUser(id, user){
    return apiClient.put(`/users/${id}`, user);
  },
  updatePassword(id, confidentials){
    return apiClient.put(`/users/${id}/update_password`, confidentials)
  },
  deleteUser(id){
    return apiClient.delete(`/users/${id}`);
  },
  getUser(id){
    return apiClient.get(`/users/${id}`);
  },
  getUsers(){
    return apiClient.get('/users');
  },
  getComments(blog_id){
    return apiClient.get(`/blogs/${blog_id}/comments`);
  },
  getComment(blog_id, comment_id){
    return apiClient.get(`/blogs/${blog_id}/comments/${comment_id}`)
  },
  createComment(blog_id, comment){
    return apiClient.post(`/blogs/${blog_id}/comments`, comment);
  },
  updateComment(blog_id, comment_id, comment){
    return apiClient.put(`/blogs/${blog_id}/comments/${comment_id}`, comment);
  },
  deleteComment(blog_id, comment_id){
    return apiClient.delete(`/blogs/${blog_id}/comments/${comment_id}`);
  },
  getRoles(){
    return apiClient.get('/roles');
  },
  getRole(id){
    return apiClient.get(`/roles/${id}`);
  },
  updateRole(user_id, role_val){
    return apiClient.put(`/users/${user_id}/update_role`, role_val);
  },
  updateBanStatus(user_id, ban_status){
    return apiClient.put(`/users/${user_id}/update_ban_status`, ban_status);
  }
}