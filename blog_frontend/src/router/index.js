import { createRouter, createWebHistory } from 'vue-router'
import HomeView from '../views/HomeView.vue'
import BlogList from '@/views/BlogList.vue'
import BlogDetail from '@/views/BlogDetail.vue'
import BlogCreate from '@/views/BlogCreate.vue'
import BlogEdit from '@/views/BlogEdit.vue'
import Login from '@/views/Login.vue'
import Signup from '@/views/Signup.vue'
import Profile from '@/views/Profile.vue'
import Admin from '@/views/Admin.vue'
import UserDetail from '@/views/UserDetail.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'Home',
      component: HomeView
    },
    {
      path: '/blogs',
      name: 'BlogList',
      component: BlogList
    },
    {
      path: '/blogs/:id',
      name: 'BlogDetail',
      component: BlogDetail
    },
    {
      path: '/blogs/new',
      name: 'BlogCreate',
      component: BlogCreate
    },
    {
      path: '/blogs/:id/edit',
      name: 'BlogEdit',
      component: BlogEdit
    },
    {
      path: '/login',
      name: 'Login',
      component: Login
    },
    {
      path: '/signup',
      name: 'Signup',
      component: Signup
    },
    {
      path: '/profile',
      name: 'Profile',
      component: Profile
    },
    {
      path: '/admin',
      name: 'Admin',
      component: Admin
    },
    {
      path: '/user_details/:id',
      name: 'UserDetail',
      component: UserDetail
    }
  ]
})

router.beforeEach((to, from, next) => {
  const publicPages = ['/login', '/signup'];
  const authRequired = !publicPages.includes(to.path);
  const loggedIn = localStorage.getItem('access_token');

  if(authRequired && !loggedIn){
    return next('/login');
  }

  next();
});

export default router
