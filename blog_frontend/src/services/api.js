import axios from 'axios';

const apiClient = axios.create({
  baseURL: 'http://localhost:3000/api/v1',
  withCredentials: true,
  headers: {
    'Content-Type': 'application/json'
  }
});

apiClient.interceptors.request.use(config => {
  const token = localStorage.getItem('access_token');

  if (token) {
    config.headers['Authorization'] = `Bearer ${token}`;
  }

  return config;
}, error => {
  return Promise.reject(error);
});

apiClient.interceptors.response.use(response => {
  return response;
}, async error => {
  const originalRequest = error.config;
  if (error.response.status === 401 && !originalRequest._retry) {
    originalRequest._retry = true;
    try {
      const response = await axios.post('http://localhost:3000/api/v1/refresh');
      localStorage.setItem('access_token', response.data.access);
      apiClient.defaults.headers['Authorization'] = `Bearer ${response.data.access}`;

      return apiClient(originalRequest);
    } catch (refreshError) {
      localStorage.removeItem('access_token');
      router.push('/login');
      return Promise.reject(refreshError);
    }
  }

  return Promise.reject(error);
});

export default apiClient;