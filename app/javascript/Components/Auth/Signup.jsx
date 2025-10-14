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
        if (!name || name.trim().length < 3) errors.push("Name must be at least 3 characters");
        if (!email.match(/^[^\s@]+@[^\s@]+\.[^\s@]+$/)) errors.push("Invalid email format");
        if (!password || password.length < 6) errors.push("Password must be at least 6 characters");
        if (password !== passwordConfirmation) errors.push("Passwords do not match");
        if (phone && !phone.match(/^\d+$/)) errors.push("Phone must contain digits only");

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
                name, email, password,
                password_confirmation: passwordConfirmation,
                phone, is_admin: isAdmin
            });

            localStorage.setItem("token", res.data.token);
            localStorage.setItem("user", JSON.stringify(res.data.user));
            setMessage(`Signup successful! Welcome, ${res.data.user.name}`);

            setTimeout(() => {
                if (res.data.user.is_admin) navigate("/admin");
                else navigate("/dashboard");
            }, 1500);

        } catch (err) {
            setMessage(err.response?.data?.errors ? err.response.data.errors.join(", ") : "Signup failed. Please try again.");
        }
    };

    return (
        <div style={{ maxWidth: "400px", margin: "40px auto", textAlign: "center" }}>
            <h2>Signup</h2>
            {message && (
                <div style={{marginBottom: "15px", padding: "10px", borderRadius: "5px", backgroundColor: message.includes("successful") ? "#d4edda" : "#f8d7da", color: message.includes("successful") ? "#155724" : "#721c24",}}>
                    {message}
                </div>
            )}
            <form onSubmit={handleSubmit}>
                <input value={name} onChange={(e) => setName(e.target.value)} placeholder="Name" required /><br /><br />
                <input value={email} onChange={(e) => setEmail(e.target.value)} placeholder="Email" type="email" required /><br /><br />
                <input type="password" value={password} onChange={(e) => setPassword(e.target.value)} placeholder="Password" required /><br /><br />
                <input type="password" value={passwordConfirmation} onChange={(e) => setPasswordConfirmation(e.target.value)} placeholder="Confirm Password" required /><br /><br />
                <input value={phone} onChange={(e) => setPhone(e.target.value)} placeholder="Phone" /><br /><br />
                <button type="submit">Signup</button>
            </form>
        </div>
    );
}

export default Signup;
