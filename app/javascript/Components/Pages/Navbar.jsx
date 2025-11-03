import React, { useState } from "react";
import { Link, useNavigate } from "react-router-dom";
import "../Css/Navbar.css";

const Navbar = () => {
    const token = localStorage.getItem("token");
    const isAdmin = localStorage.getItem("isAdmin") === "true";
    const userName = localStorage.getItem("userName");
    const [showDropdown, setShowDropdown] = useState(false);
    const navigate = useNavigate();

    const handleLogout = () => {
        localStorage.clear();
        navigate("/");
    };

    const handleDashboard = () => {
        navigate("/dashboard");
    };

    return (
        <nav className="navbar">
            <div className="navbar-left">
                <Link to="/" className="nav-logo">Movie Reservation</Link>
                <Link to="/" className="nav-link">Home</Link>
                <Link to="/movies" className="nav-link">Movies</Link>
                {isAdmin && token && <Link to="/admin" className="nav-link">Admin</Link>}
            </div>

            <div className="navbar-right">
                {!token && (
                    <>
                        <Link to="/login" className="button-link">Login</Link>
                        <Link to="/signup" className="button-link signup">Signup</Link>
                    </>
                )}

                {token && (
                    <div style={{ position: "relative" }}>
                        <button className="button-link" onClick={() => setShowDropdown(!showDropdown)}>
                            {userName || "User"} ▼
                        </button>
                        {showDropdown && (
                            <div className="user-dropdown">
                                <button className="button-link dashboard" onClick={handleDashboard}>
                                    Dashboard
                                </button>
                                <button className="button-link logout" onClick={handleLogout}>
                                    Logout
                                </button>
                            </div>
                        )}
                    </div>
                )}
            </div>
        </nav>
    );
};

export default Navbar;
