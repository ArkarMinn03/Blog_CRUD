<template>
  <div class="container mt-3 p-2">
    <h3>User List</h3>
    <!-- <table class="table">
      <thead>
        <tr>
          <th>ID</th>
          <th>Name</th>
          <th>Email</th>
          <th>Status</th>
          <th>Role</th>
          <th>Actions</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="user in users" :key="user.id">
          <td>{{ user.id }}</td>
          <td>{{ user.name }}</td>
          <td>{{ user.email }}</td>
          <td>
            <button v-if="user.isBanned == 0" class="btn btn-sm btn-outline-danger"
              @click="changeBanStatus(user.id, 1)">
              Ban
            </button>
            <button v-else class="btn btn-sm btn-outline-secondary" @click="changeBanStatus(user.id, 0)">
              Release
            </button>
          </td>
          <td>
            <div class="dropdown">
              <button class="btn btn-sm dropdown-toggle" type="button" data-bs-toggle="dropdown"
                :class="getRoleClass(user.role_value)" :disabled="current_user.role_value > 1">
                {{ getRoleName(user.role_value) }}
              </button>
              <ul class="dropdown-menu">
                <li v-for="role in roles" :key="role.id">
                  <a class="dropdown-item" :class="{ active: user.role_value == role.value }" href="#"
                    @click="changeRole(user.id, role.value)">
                    {{ role.name }}
                  </a>
                </li>
              </ul>
            </div>
          </td>
          <td>
            <button class="btn btn-sm btn-secondary me-2">Edit</button>
            <button class="btn btn-sm btn-danger">Delete</button>
          </td>
        </tr>
      </tbody>
    </table> -->

    <div class="row mt-3 p-3">
      <div v-for="user in users" :key="user.id" class="col-4 p-2">
        <div class="bg-light rounded-3 p-3">
          <div class="position-relative">
            <router-link :to="`/user_details/${user.id}`" class="text-dark text-decoration-none d-block">
              <span v-if="user.isBanned == 1" class="badge text-bg-danger float-end">Banned</span>
              <div class="mb-2">ID: {{ user.id }}</div>
              <div class="mb-2">Name: {{ user.name }}</div>
              <div class="mb-2">Email: {{ user.email }}</div>
              <div>
                Role: <span :class="getRoleClass(user.role_value)">{{ getRoleName(user.role_value) }}</span>
              </div>
            </router-link>
            <div class="position-absolute bottom-0 end-0">
              <button v-if="user.isBanned == 0" class="btn btn-sm btn-outline-danger float-end" style="width: 75px"
                @click="changeBanStatus(user.id, 1)">
                Ban
              </button>
              <button v-else class="btn btn-sm btn-outline-secondary float-end" @click="changeBanStatus(user.id, 0)"
                style="width: 75px">
                Release
              </button>
            </div>
          </div>
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
      users: [],
      roles: [],
    }
  },
  props: {
    current_user: Object
  },
  methods: {
    async fetchUsers() {
      const response = await blogService.getUsers();
      this.users = response.data;
    },
    async fetchRoles() {
      const response = await blogService.getRoles();
      this.roles = response.data;
    },
    async changeRole(user_id, role_val) {
      if (confirm('Changing roles! You sure about this?')) {
        const role = {
          role_value: role_val
        };
        await blogService.updateRole(user_id, role);

        const index = this.users.findIndex(user => user.id == user_id);
        if (index !== -1) {
          this.users[index].role_value = role_val;
        }
      }
    },
    async changeBanStatus(user_id, banStatus) {

      if (confirm('You sure you wanna do this?')) {
        const status = {
          'isBanned': banStatus
        };
        await blogService.updateBanStatus(user_id, status);

        const index = this.users.findIndex(user => user.id == user_id);
        if (index !== -1) {
          this.users[index].isBanned = banStatus;
        }
      }
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
          return 'text-success';
        case 2:
          return 'text-primary';
        case 3:
          return 'text-secondary';
        default:
          return 'text-dark'
      }
    }
  },
  created() {
    this.fetchUsers();
    this.fetchRoles();
  },
}
</script>