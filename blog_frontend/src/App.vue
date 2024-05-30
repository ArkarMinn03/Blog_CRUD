<script setup>
import { RouterView, useRoute } from 'vue-router'
import NavBar from '@/components/NavBar.vue'
import { ref, watch } from 'vue';
import { jwtDecode } from 'jwt-decode';
import blogService from './services/blogService';

const isLoggedIn = ref(false);
const route = useRoute();
const current_user = ref({});

watch(route, () => {
  const userToken = localStorage.getItem('access_token');
  isLoggedIn.value = !!userToken;

  if (isLoggedIn.value) {
    const userID = jwtDecode(userToken).user_id
    blogService.getUser(userID)
      .then(user => {
        current_user.value = user.data
      })
      .catch(error => {
        console.error('Fail to get current user', error)
      })
  }
})

</script>

<template>
  <NavBar :isAuth="isLoggedIn" :current_user="current_user" />
  <RouterView :current_user="current_user" />
</template>
