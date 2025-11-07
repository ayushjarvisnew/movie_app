import React from "react";
import { Navigate } from "react-router-dom";

const UserRoute = ({ children }) => {
    const token = localStorage.getItem("token");
    const isAdmin = localStorage.getItem("isAdmin") === "true";

    if (!token) {
        return <Navigate to="/login" replace />;
    }

    if (isAdmin) {
        return <Navigate to="/admin" replace />;
    }

    return children;
};

export default UserRoute;
