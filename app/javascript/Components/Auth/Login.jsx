import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import axios from "axios";

const Login = () => {
    const [email, setEmail] = useState("");
    const [password, setPassword] = useState("");
    const navigate = useNavigate();

    const handleLogin = (e) => {
        e.preventDefault();
        axios.post("http://localhost:3000/login", { email, password })
            .then(res => {
                const { token, user } = res.data;
                localStorage.setItem("token", token);
                localStorage.setItem("isAdmin", user.is_admin);
                localStorage.setItem("userName", user.name);
                navigate("/");

            })
            .catch(() => alert("Invalid credentials"));
    };

    return (
        <div className="login-form">
            <h2>Login</h2>
            <form onSubmit={handleLogin}>
                <input type="email" placeholder="Email" value={email}
                    onChange={e => setEmail(e.target.value)} required/>
                <input type="password" placeholder="Password" value={password}
                    onChange={e => setPassword(e.target.value)} required/>
                <button type="submit">Login</button>
            </form>
        </div>
    );
};

export default Login;

















































































// // async function fetchData() {
// //     console.log("Before await");
// //     const response = await axios.get("http://localhost:3000/movies");
// //     console.log("After await", response.data);
// // }
// // Before await
// //     (Waits until axios finishes fetching)
// // After await [movies array]
//
