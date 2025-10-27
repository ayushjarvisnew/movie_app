import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import axios from "axios";

const Login = () => {
    const [email, setEmail] = useState("");
    const [password, setPassword] = useState("");
    const [showPassword, setShowPassword] = useState(false);
    const [message, setMessage] = useState("");
    const navigate = useNavigate();

    const handleLogin = async (e) => {
        e.preventDefault();
        try {
            const res = await axios.post("http://localhost:3000/login", { email, password });
            const { token, user } = res.data;
            localStorage.setItem("token", token);
            localStorage.setItem("isAdmin", user.is_admin);
            localStorage.setItem("user", JSON.stringify(user));
            setMessage(`Welcome back, ${user.name}!`);
            setTimeout(() => {
                if (user.is_admin) navigate("/admin");
                else navigate("/dashboard");
            }, 1000);
        } catch (err) {
            setMessage("Invalid email or password");
        }
    };

    return (
        <div
            style={{
                maxWidth: "400px",
                margin: "50px auto",
                textAlign: "center",
                backgroundColor: "#fff",
                padding: "30px",
                borderRadius: "10px",
                boxShadow: "0 2px 10px rgba(0,0,0,0.15)",
            }}
        >
            <h2 style={{ marginBottom: "20px" }}>Login</h2>
            {message && (
                <div
                    style={{
                        marginBottom: "15px",
                        padding: "10px",
                        borderRadius: "5px",
                        backgroundColor: message.includes("Welcome") ? "#d4edda" : "#f8d7da",
                        color: message.includes("Welcome") ? "#155724" : "#721c24",
                    }}
                >
                    {message}
                </div>
            )}
            <form onSubmit={handleLogin}>
                <input
                    type="email"
                    placeholder="Email"
                    value={email}
                    onChange={(e) => setEmail(e.target.value)}
                    required
                    style={{
                        width: "100%",
                        padding: "12px",
                        marginBottom: "15px",
                        borderRadius: "5px",
                        border: "1px solid #ccc",
                        boxSizing: "border-box",
                    }}
                />
                <div style={{ position: "relative", marginBottom: "20px" }}>
                    <input
                        type={showPassword ? "text" : "password"}
                        placeholder="Password"
                        value={password}
                        onChange={(e) => setPassword(e.target.value)}
                        required
                        style={{
                            width: "100%",
                            padding: "12px",
                            borderRadius: "5px",
                            border: "1px solid #ccc",
                            boxSizing: "border-box",
                        }}
                    />
                    <span
                        onClick={() => setShowPassword(!showPassword)}
                        style={{
                            position: "absolute",
                            right: "10px",
                            top: "50%",
                            transform: "translateY(-50%)",
                            cursor: "pointer",
                            color: "#007bff",
                            fontWeight: "bold",
                            userSelect: "none",
                        }}
                    >
                        {showPassword ? "Hide" : "Show"}
                    </span>
                </div>
                <button
                    type="submit"
                    style={{
                        width: "100%",
                        padding: "12px",
                        borderRadius: "5px",
                        backgroundColor: "#007bff",
                        color: "#fff",
                        border: "none",
                        cursor: "pointer",
                        fontWeight: "bold",
                    }}
                >
                    Login
                </button>
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
