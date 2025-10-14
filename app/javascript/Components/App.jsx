import React from "react";
import { BrowserRouter as Router, Routes, Route } from "react-router-dom";

import Navbar from "./Pages/Navbar";
import Home from "./Pages/Home";
import Login from "./Auth/Login";
import Signup from "./Auth/Signup";
import AdminRoute from "./AdminRoute";
import UserRoute from "./UserRoute";
import Movies from "./Pages/Movies";
import Admin from "./Pages/Admin";

import UserDashboard from "./Pages/UserDashboard";
// We'll put AdminRoute in Pages or MovieForm folder
import Theatres from "./Pages/Theatres";
import Screens from "./Pages/Screens";
import Showtime from "./Pages/Showtime";
import UserReservation from "./Pages/UserReservation";


function App() {
    return (
        <Router>
            <Navbar />
            <Routes>
                <Route path="/" element={<Home />} />
                <Route path="/login" element={<Login />} />
                <Route path="/signup" element={<Signup />} />
                <Route path="/admin" element={<AdminRoute><Admin /></AdminRoute>}/>
                <Route path="/dashboard" element={<UserRoute><UserDashboard /></UserRoute>} />
                <Route path="/movies" element={<Movies />} />

                <Route path="/theatres" element={<Theatres />} />
                <Route path="/screens" element={<Screens />} />
                <Route path="/showtimes" element={<Showtime />} />
                <Route path="/reservation" element={<UserReservation />} />
            </Routes>
        </Router>
    );
}

export default App;
