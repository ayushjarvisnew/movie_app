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
            const res = await axios.post("/login", { email, password });
            const { token, user } = res.data;

            localStorage.setItem("token", token);
            localStorage.setItem("isAdmin", user.is_admin);
            localStorage.setItem("user", JSON.stringify(user));
            localStorage.setItem("userName", user.name);

            setMessage(`Welcome back, ${user.name}!`);

            setTimeout(() => {
               navigate("/");
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
                fontFamily: "Arial, sans-serif",
            }}
        >
            <h2 style={{ marginBottom: "20px", color: "#333" }}>Login</h2>

            {message && (
                <div
                    style={{
                        marginBottom: "15px",
                        padding: "10px",
                        borderRadius: "5px",
                        backgroundColor: message.includes("Welcome") ? "#d4edda" : "#f8d7da",
                        color: message.includes("Welcome") ? "#155724" : "#721c24",
                        border: message.includes("Welcome")
                            ? "1px solid #c3e6cb"
                            : "1px solid #f5c6cb",
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
                        fontSize: "14px",
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
                            fontSize: "14px",
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
                            fontSize: "13px",
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
                        fontSize: "15px",
                        transition: "background-color 0.2s ease",
                    }}
                    onMouseOver={(e) => (e.target.style.backgroundColor = "#0056b3")}
                    onMouseOut={(e) => (e.target.style.backgroundColor = "#007bff")}
                >
                    Login
                </button>
            </form>
        </div>
    );
};

export default Login;
