import React from "react";
import ReactDOM from "react-dom/client";
import App from "./Components/App";
import axios from "axios";

document.addEventListener("DOMContentLoaded", () => {
    // Set CSRF token for all Axios requests
    axios.defaults.withCredentials = true;
    const token = document.querySelector('meta[name="csrf-token"]')?.getAttribute('content');
    if (token) {
        axios.defaults.headers.common['X-CSRF-Token'] = token;
    }

    const root = ReactDOM.createRoot(document.getElementById("root"));
    root.render(<App/>);
});


