import React, { useState } from "react";
import axios from "axios";
// import axios from "../../api/axios";
import { useNavigate } from "react-router-dom";

const Signup = () => {
    const [name, setName] = useState("");
    const [email, setEmail] = useState("");
    const [password, setPassword] = useState("");
    const [passwordConfirmation, setPasswordConfirmation] = useState("");
    const [phone, setPhone] = useState("");
    const [isAdmin, setIsAdmin] = useState(false);
    const [message, setMessage] = useState("");

    const navigate = useNavigate();

    // Validation logic
    const validate = () => {
        const errors = [];
        const passwordRegex =
            /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z0-9]).{8,20}$/;

        if (!name || name.trim().length < 3)
            errors.push("Name must be at least 3 characters long");
        if (!email.match(/^[^\s@]+@[^\s@]+\.[^\s@]+$/))
            errors.push("Invalid email format");
        if (!password.match(passwordRegex))
            errors.push(
                "Password must be 8–20 chars, include uppercase, lowercase, number, and special character"
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
            const res = await axios.post("/signup", {
                name,
                email,
                password,
                password_confirmation: passwordConfirmation,
                phone,
                is_admin: isAdmin,
            },{ withCredentials: true });

            localStorage.setItem("token", res.data.token);
            localStorage.setItem("user", JSON.stringify(res.data.user));
            setUser(res.data.user);
            setMessage(`Signup successful! Welcome, ${res.data.user.name}`);

            setTimeout(() => {
                navigate("/");
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
                margin: "50px auto",
                textAlign: "center",
                backgroundColor: "#fff",
                padding: "30px",
                borderRadius: "10px",
                boxShadow: "0 2px 10px rgba(0,0,0,0.15)",
                fontFamily: "Arial, sans-serif",
            }}
        >
            <h2 style={{ marginBottom: "20px", color: "#333" }}>Signup</h2>

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
                        border: message.includes("successful")
                            ? "1px solid #c3e6cb"
                            : "1px solid #f5c6cb",
                    }}
                >
                    {message}
                </div>
            )}

            <form onSubmit={handleSubmit}>
                <input
                    type="text"
                    placeholder="Name"
                    value={name}
                    onChange={(e) => setName(e.target.value)}
                    required
                    style={{
                        width: "100%",
                        padding: "12px",
                        marginBottom: "12px",
                        borderRadius: "5px",
                        border: "1px solid #ccc",
                        boxSizing: "border-box",
                        fontSize: "14px",
                    }}
                />

                <input
                    type="email"
                    placeholder="Email"
                    value={email}
                    onChange={(e) => setEmail(e.target.value)}
                    required
                    style={{
                        width: "100%",
                        padding: "12px",
                        marginBottom: "12px",
                        borderRadius: "5px",
                        border: "1px solid #ccc",
                        boxSizing: "border-box",
                        fontSize: "14px",
                    }}
                />

                <input
                    type="password"
                    placeholder="Password (8–20 chars, mix case, number, special)"
                    value={password}
                    onChange={(e) => setPassword(e.target.value)}
                    required
                    style={{
                        width: "100%",
                        padding: "12px",
                        marginBottom: "12px",
                        borderRadius: "5px",
                        border: "1px solid #ccc",
                        boxSizing: "border-box",
                        fontSize: "14px",
                    }}
                />

                <input
                    type="password"
                    placeholder="Confirm Password"
                    value={passwordConfirmation}
                    onChange={(e) => setPasswordConfirmation(e.target.value)}
                    required
                    style={{
                        width: "100%",
                        padding: "12px",
                        marginBottom: "12px",
                        borderRadius: "5px",
                        border: "1px solid #ccc",
                        boxSizing: "border-box",
                        fontSize: "14px",
                    }}
                />

                <input
                    type="text"
                    placeholder="Phone"
                    value={phone}
                    onChange={(e) =>
                        setPhone(e.target.value.replace(/\D/g, "").slice(0, 10))
                    }
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
                    Signup
                </button>
            </form>
        </div>
    );
};

export default Signup;
