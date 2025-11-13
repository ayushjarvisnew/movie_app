import axios from "axios";

// Use environment variable if available, otherwise default to current host
const baseURL = process.env.REACT_APP_API_URL || window.location.origin;

const instance = axios.create({
    baseURL,
    withCredentials: true, // important for Rails cookies or sessions
});

export default instance;
