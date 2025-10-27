import React, { useState, useEffect } from "react";
import { Link, useNavigate } from "react-router-dom";
import "../Css/Navbar.css";

const Navbar = () => {
    const [token, setToken] = useState(null);
    const [isAdmin, setIsAdmin] = useState(false);
    const [userName, setUserName] = useState("");
    const [showDropdown, setShowDropdown] = useState(false);

    const navigate = useNavigate();

    // Load user info from localStorage on mount
    useEffect(() => {
        const storedToken = localStorage.getItem("token");
        const storedAdmin = localStorage.getItem("isAdmin") === "true";
        const storedName = localStorage.getItem("userName");

        setToken(storedToken);
        setIsAdmin(storedAdmin);
        setUserName(storedName);
    }, []);

    const handleLogout = () => {
        localStorage.clear();
        setToken(null);
        setIsAdmin(false);
        setUserName("");
        navigate("/"); // redirect to home
    };

    const handleDashboard = () => {
        navigate("/dashboard"); // redirect to dashboard page
    };

    return (
        <nav className="navbar">
            <div className="navbar-left">
                <Link to="/" className="nav-logo">Movie Reservation</Link>
                <Link to="/" className="nav-link">Home</Link>
                <Link to="/movies" className="nav-link">Movies</Link>
                {isAdmin && token && (
                    <Link to="/admin" className="nav-link">Admin</Link>
                )}
            </div>

            <div className="navbar-right">
                {!token ? (
                    <>
                        <Link to="/login" className="button-link">Login</Link>
                        <Link to="/signup" className="button-link signup">Signup</Link>
                    </>
                ) : (
                    <div style={{ position: "relative" }}>
                        <button
                            className="button-link"
                            onClick={() => setShowDropdown(!showDropdown)}
                        >
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
