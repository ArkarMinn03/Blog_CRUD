<template>
  <div class="container mt-5" style="max-width: 800px;">
    <h4 class="text-center">{{ user_name }}'s Details</h4>
    <div v-if="message" class="alert alert-info">
      {{ message }}
    </div>
    <div class="row mt-5">
      <div class="col-7 border-end-2">
        <div class="bg-light rounded p-3">
          <form @submit.prevent="updateUser">
            <div class="row gx-1 mb-4 align-items-center">
              <div class="col-2 text-end pe-2">ID : </div>
              <div class="col text-start">
                <input type="text" class="form-control" disabled v-model="user_id">
              </div>
            </div>
            <div class="row gx-1  mb-4 align-items-center">
              <div class="col-2 text-end pe-2">Name : </div>
              <div class="col text-start">
                <input type="text" class="form-control" v-model="user_name">
              </div>
            </div>
            <div class="row gx-1  mb-4 align-items-center">
              <div class="col-2 text-end pe-2">Email : </div>
              <div class="col text-start">
                <input type="email" class="form-control" v-model="user_email">
              </div>
            </div>
            <div class="d-flex justify-content-end">
              <button type="reset" class="btn btn-outline-secondary me-2">Cancel</button>
              <button type="submit" class="btn btn-primary">Update</button>
            </div>
          </form>
        </div>
      </div>
      <div class="col-5 p-3">
        <div>
          <ul class="list-group list-group-flush">
            <li class="list-group-item py-3">
              Change Role :
              <div class="dropdown ms-3 d-inline-block float-end">
                <button class="btn btn-sm dropdown-toggle" type="button" data-bs-toggle="dropdown"
                  :class="getRoleClass(user_role_value)" :disabled="current_user.role_value > 1" style="width: 100px;">
                  {{ getRoleName(user_role_value) }}&nbsp;
                </button>
                <ul class="dropdown-menu">
                  <li v-for="role in roles" :key="role.id">
                    <a class="dropdown-item" :class="{ active: user_role_value == role.value }" href="#"
                      @click="changeRole(user_id, role.value)">
                      {{ role.name }}
                    </a>
                  </li>
                </ul>
              </div>
            </li>
            <li class="list-group-item py-3">
              Ban User :
              <button v-if="user_isBanned == 0" class="btn btn-sm btn-outline-danger ms-3 float-end"
                @click="changeBanStatus(user_id, 1)" style="width: 100px;">
                Ban
              </button>
              <button v-else class="btn btn-sm btn-outline-secondary ms-3 float-end"
                @click="changeBanStatus(user_id, 0)" style="width: 100px;">
                Release
              </button>
            </li>
            <li class="list-group-item py-3">
              Delete this account :
              <button class="btn btn-sm btn-danger d-inline-block ms-3 float-end" style="width: 100px;"
                @click="deleteUser">Delete</button>
            </li>
          </ul>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import blogService from '@/services/blogService';

export default {
  data() {
    return {
      user_id: null,
      user_name: '',
      user_email: '',
      user_isBanned: null,
      user_role_value: null,
      roles: [],
      message: '',
    }
  },
  props: {
    current_user: Object
  },
  methods: {
    async fetchUser() {
      const response = await blogService.getUser(this.$route.params.id);
      const user = response.data;
      this.user_id = user.id;
      this.user_name = user.name;
      this.user_email = user.email;
      this.user_isBanned = user.isBanned;
      this.user_role_value = user.role_value;
    },
    async fetchRoles() {
      const response = await blogService.getRoles();
      this.roles = response.data;
    },
    async updateUser() {
      const user = {
        name: this.user_name,
        email: this.user_email
      }
      const response = await blogService.updateUser(this.user_id, user);
      this.message = response.data.message;
    },
    async changeBanStatus(user_id, banStatus) {
      if (confirm('You sure you wanna do this?')) {
        const status = {
          'isBanned': banStatus
        };
        await blogService.updateBanStatus(user_id, status);

        this.user_isBanned = banStatus;
      }
    },
    async changeRole(user_id, role_val) {
      if (confirm('Changing roles! You sure about this?')) {
        const role = {
          role_value: role_val
        };
        await blogService.updateRole(user_id, role);
        this.user_role_value = role_val;
      }
    },
    async deleteUser() {
      const response = await blogService.deleteUser(this.user_id);
      this.$router.push('/admin');
    },
    getRoleName(value) {
      const role = this.roles.find(role => role.value == value);
      if (role) {
        return role.name;
      }
    },
    getRoleClass(value) {
      switch (value) {
        case 1:
          return 'btn-success';
        case 2:
          return 'btn-primary';
        case 3:
          return 'btn-secondary';
        default:
          return 'btn-dark'
      }
    }
  },
  created() {
    this.fetchUser();
    this.fetchRoles();
  }
}
</script>