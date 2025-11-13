// import axios from "axios";
//
// // Use environment variable if available, otherwise default to current host
// const baseURL = process.env.REACT_APP_API_URL || window.location.origin;
//
// const instance = axios.create({
//     baseURL,
//     withCredentials: true, // important for Rails cookies or sessions
// });
//
// export default instance;
import axios from "axios";

// Determine baseURL safely
// - Use environment variable if available (injected at build time)
// - Fallback to window.location.origin if process.env is undefined (browser)
const baseURL =
    (typeof process !== "undefined" && process.env.REACT_APP_API_URL)
        ? process.env.REACT_APP_API_URL
        : window.location.origin;

console.log("Axios baseURL:", baseURL); // helps debugging

const instance = axios.create({
    baseURL,
    withCredentials: true, // required for Rails cookies or JWT
});

export default instance;
