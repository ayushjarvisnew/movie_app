import React from "react";
import { Navigate } from "react-router-dom";
const UserRoute = ({ children }) => {
    const token = localStorage.getItem("token");

    if (!token) {
        // if not logged in, redirect to login page
        return <Navigate to="/login" replace />;
    }

    return children;
};

export default UserRoute;
