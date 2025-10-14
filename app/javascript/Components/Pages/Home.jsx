import React from "react";
import { Link } from "react-router-dom";
import "../Css/Home.css"; // your CSS file

const Home = () => {
    return (
        <div className="home-container">
            <h1>Welcome to Movie Reservation System</h1>
            <p>Browse movies, book seats, and manage your reservations.</p>

            <div>
                <Link to="/movies" className="button-link">
                    View Movies
                </Link>
            </div>
        </div>
    );
};

export default Home;
