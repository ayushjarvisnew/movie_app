import React, { useState } from "react";
import axios from "axios";
import { useNavigate } from "react-router-dom";

function Signup() {
    const [name, setName] = useState("");
    const [email, setEmail] = useState("");
    const [password, setPassword] = useState("");
    const [passwordConfirmation, setPasswordConfirmation] = useState("");
    const [phone, setPhone] = useState("");
    const [isAdmin, setIsAdmin] = useState(false);
    const [message, setMessage] = useState("");

    const navigate = useNavigate();

    const validate = () => {
        const errors = [];
        const passwordRegex =
            /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z0-9]).{8,20}$/;

        if (!name || name.trim().length < 3)
            errors.push("Name must be at least 3 characters");
        if (!email.match(/^[^\s@]+@[^\s@]+\.[^\s@]+$/))
            errors.push("Invalid email format");
        if (!password.match(passwordRegex))
            errors.push(
                "Password must be 8–20 characters and include at least one uppercase letter, one lowercase letter, one number, and one special character"
            );
        if (password !== passwordConfirmation)
            errors.push("Passwords do not match");
        if (phone && !phone.match(/^\d+$/))
            errors.push("Phone must contain digits only");

        if (errors.length > 0) {
            setMessage(errors.join(", "));
            return false;
        }
        return true;
    };

    const handleSubmit = async (e) => {
        e.preventDefault();
        if (!validate()) return;

        try {
            const res = await axios.post("http://localhost:3000/signup", {
                name,
                email,
                password,
                password_confirmation: passwordConfirmation,
                phone,
                is_admin: isAdmin,
            });

            localStorage.setItem("token", res.data.token);
            localStorage.setItem("user", JSON.stringify(res.data.user));
            setMessage(`Signup successful! Welcome, ${res.data.user.name}`);

            setTimeout(() => {
                if (res.data.user.is_admin) navigate("/admin");
                else navigate("/dashboard");
            }, 1500);
        } catch (err) {
            setMessage(
                err.response?.data?.errors
                    ? err.response.data.errors.join(", ")
                    : "Signup failed. Please try again."
            );
        }
    };

    return (
        <div
            style={{
                maxWidth: "400px",
                margin: "40px auto",
                textAlign: "center",
                backgroundColor: "#fff",
                padding: "20px",
                borderRadius: "10px",
                boxShadow: "0 2px 8px rgba(0,0,0,0.1)",
            }}
        >
            <h2 style={{ marginBottom: "20px" }}>Signup</h2>
            {message && (
                <div
                    style={{
                        marginBottom: "15px",
                        padding: "10px",
                        borderRadius: "5px",
                        backgroundColor: message.includes("successful")
                            ? "#d4edda"
                            : "#f8d7da",
                        color: message.includes("successful")
                            ? "#155724"
                            : "#721c24",
                    }}
                >
                    {message}
                </div>
            )}
            <form onSubmit={handleSubmit}>
                <input
                    value={name}
                    onChange={(e) => setName(e.target.value)}
                    placeholder="Name"
                    required
                    style={{ width: "100%", padding: "10px", marginBottom: "10px" }}
                />
                <input
                    value={email}
                    onChange={(e) => setEmail(e.target.value)}
                    placeholder="Email"
                    type="email"
                    required
                    style={{ width: "100%", padding: "10px", marginBottom: "10px" }}
                />
                <input
                    type="password"
                    value={password}
                    onChange={(e) => setPassword(e.target.value)}
                    placeholder="Password (8–20 chars, mix case, number, special)"
                    required
                    style={{ width: "100%", padding: "10px", marginBottom: "10px" }}
                />
                <input
                    type="password"
                    value={passwordConfirmation}
                    onChange={(e) => setPasswordConfirmation(e.target.value)}
                    placeholder="Confirm Password"
                    required
                    style={{ width: "100%", padding: "10px", marginBottom: "10px" }}
                />
                <input
                    value={phone}
                    onChange={(e) => setPhone(e.target.value)}
                    placeholder="Phone"
                    style={{ width: "100%", padding: "10px", marginBottom: "10px" }}
                />
                <button
                    type="submit"
                    style={{
                        width: "100%",
                        padding: "10px",
                        backgroundColor: "#007bff",
                        color: "white",
                        border: "none",
                        borderRadius: "5px",
                        cursor: "pointer",
                    }}
                >
                    Signup
                </button>
            </form>
        </div>
    );
}

export default Signup;

